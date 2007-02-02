Return-Path: <linux-kernel-owner+w=401wt.eu-S1422971AbXBBHVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422971AbXBBHVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422973AbXBBHVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:21:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:58393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422971AbXBBHVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:21:09 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@osdl.org>
Subject: Re: i386 and x86-64 bitops function prototypes differ
Date: Fri, 2 Feb 2007 08:12:04 +0100
User-Agent: KMail/1.9.5
Cc: eranian@hpl.hp.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
References: <20070126143555.GL11525@frankl.hpl.hp.com> <20070201091555.GA32377@frankl.hpl.hp.com> <20070201145525.d4d950c0.akpm@osdl.org>
In-Reply-To: <20070201145525.d4d950c0.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020812.04464.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> So I'd say that x86_64 is wrong, and should be changed to take ulong*.

I'm trying to remember why I used void * -- I think there was a reason,
but it's lost in the myst of time.

Anyways, I suspect changing it now would have quite some fallout on other
code, but hopefully limited to arch/x86_64/*. But fixing these up
will hopefully not be too hard. 

-Andi



