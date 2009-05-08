Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZEHEl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZEHEl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZEHElR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:41:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52106 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZEHElQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:41:16 -0400
Message-ID: <4A03B7DA.8060702@zytor.com>
Date: Thu, 07 May 2009 21:40:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Sam Ravnborg <sam@ravnborg.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: fix build with older binutils
References: <4A0055B3.76EA.0078.0@novell.com> <20090505163930.GA18579@uranus.ravnborg.org> <4A015158.76EA.0078.0@novell.com>
In-Reply-To: <4A015158.76EA.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> 
> Yeah, the placement of .init.start appears to be wrong - it should the
> SMP/x86-64 case of the per-CPU segment, and it should also be the
> one getting the :init attached. Hopefully that won't get us back to the
> binutils problem I was originally encountering - what is the extra .init.start
> section good for anyway? And why does __init_end continue to live
> outside of any section (this sort of thing causes problems with
> CONFIG_RELOCATABLE and older binutils afair, as such symbols get
> marked absolute by the latter)? While this was the case (and a mistake)
> for x86-64 prior to the merge, it was properly placed in a section for
> ix86, and hence I'd view it as a regression there.
> 
> Btw., why is .data.nosave being placed differently for 32- and 64-bit?
> 

Probably for no good reason, but it might need additional fixes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

