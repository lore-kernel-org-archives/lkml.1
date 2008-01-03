Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYACNMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYACNMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYACNMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:12:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYACNMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:12:32 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
Date: Thu, 3 Jan 2008 14:12:26 +0100
User-Agent: KMail/1.9.6
Cc: schwidefsky@de.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20071112143009.425807965@de.ibm.com> <20071112144009.831296895@de.ibm.com> <20080102204435.GB15460@infradead.org>
In-Reply-To: <20080102204435.GB15460@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031412.26806.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Can we please just nuke CONFIG_HIGHPTE?  There's only been a small
> amount of 32bit machines 

It's unfortunately a larger amount :/ And for unknown reasons a lot of
people still install 32bit kernels on new perfectly capable 64bit systems
even if they have a lot of memory.

I don't think removing CONFIG_HIGHPTE will be an option any time soon.

-Andi
