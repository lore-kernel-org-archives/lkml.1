Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYHLP3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYHLP3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYHLP3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:29:07 -0400
Received: from khc.piap.pl ([195.187.100.11]:42363 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbYHLP3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:29:06 -0400
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Possible false positive in checkpatch
References: <Pine.LNX.4.44L0.0808121017510.2509-100000@iolanthe.rowland.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 12 Aug 2008 17:29:02 +0200
In-Reply-To: <Pine.LNX.4.44L0.0808121017510.2509-100000@iolanthe.rowland.org> (Alan Stern's message of "Tue\, 12 Aug 2008 10\:25\:08 -0400 \(EDT\)")
Message-ID: <m3d4kefe0x.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> ERROR: space prohibited after that '*' (ctx:BxW)


> Certainly this is a rather uncommon code construction, but similar
> ones might occur elsewhere.  To my eyes,
>
> 	(* (type *) ptr)
>
> looks better than
>
> 	(*(type *) ptr)
>
> or
>
> 	(*(type *)ptr)
>
> or even
>
> 	(*(type*)ptr)
>
> but of course this is a matter of opinion.  Is there any strong feeling 
> about this in the kernel community?

I think checkpatch already has gone way too far with this (and not
only this).

"type *var" vs "type* var" - sure, the latter is worse and provokes
"type* var1, var2", but anything else is IMHO only annoying and,
actually, not important WRT readability at all.

For example I prefer "type* func()" - as it's a function returning
"a pointer to type" and not "a pointer to a function returning type"
(which "type *func()" may suggest). Yes, func is not a pointer, so why
write "*" next to it?
-- 
Krzysztof Halasa
