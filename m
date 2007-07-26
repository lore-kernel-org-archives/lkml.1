Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbXGZASl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbXGZASl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbXGZASe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:18:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:36048 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXGZASd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:18:33 -0400
Subject: Re: pte_offset_map for ppc assumes HIGHPTE
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave McCracken <dave.mccracken@oracle.com>
Cc: Andreas Schwab <schwab@suse.de>, Satya <satyakiran@gmail.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <200707251830.21944.dave.mccracken@oracle.com>
References: <acbcf3840707251516w301f834cj5f6a81a494d359ed@mail.gmail.com>
	 <jewswodqcn.fsf@sykes.suse.de>
	 <1185405765.5439.371.camel@localhost.localdomain>
	 <200707251830.21944.dave.mccracken@oracle.com>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 10:18:13 +1000
Message-Id: <1185409094.5495.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 18:30 -0500, Dave McCracken wrote:
> On Wednesday 25 July 2007, Benjamin Herrenschmidt wrote:
> > Depends... if you have CONFIG_HIGHMEM and not CONFIG_HIGHPTE, you are
> > wasting time going through kmap_atomic unnecessarily no ? it will probably
> > not do anything because the PTE page is in lowmem but still...
> 
> Probably not much time.  You still need to do the page to virtual translation, 
> which kmap_atomic does for you.

Fair enough.

Ben.


