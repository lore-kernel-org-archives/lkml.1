Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXGYXcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXGYXcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbXGYXcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:32:14 -0400
Received: from ms-smtp-04.texas.rr.com ([24.93.47.43]:62579 "EHLO
	ms-smtp-04.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbXGYXcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:32:13 -0400
From: Dave McCracken <dave.mccracken@oracle.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: pte_offset_map for ppc assumes HIGHPTE
Date: Wed, 25 Jul 2007 18:30:21 -0500
User-Agent: KMail/1.9.7
Cc: Andreas Schwab <schwab@suse.de>, Satya <satyakiran@gmail.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <acbcf3840707251516w301f834cj5f6a81a494d359ed@mail.gmail.com> <jewswodqcn.fsf@sykes.suse.de> <1185405765.5439.371.camel@localhost.localdomain>
In-Reply-To: <1185405765.5439.371.camel@localhost.localdomain>
Organization: Oracle Corp
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251830.21944.dave.mccracken@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007, Benjamin Herrenschmidt wrote:
> Depends... if you have CONFIG_HIGHMEM and not CONFIG_HIGHPTE, you are
> wasting time going through kmap_atomic unnecessarily no ? it will probably
> not do anything because the PTE page is in lowmem but still...

Probably not much time.  You still need to do the page to virtual translation, 
which kmap_atomic does for you.

Dave McCracken
