Return-Path: <linux-kernel-owner+w=401wt.eu-S934017AbYBHJOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017AbYBHJOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759982AbYBHJOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:14:24 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36169 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861AbYBHJOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:14:21 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: David Newall <davidn@davidnewall.com>
Cc: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <47ABD317.5060805@davidnewall.com>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>
	 <47A5D9CD.5070001@davidnewall.com>
	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	 <47A5E67D.9040804@davidnewall.com>
	 <84144f020802030848v160253feoa24c5ecefc7c91f5@mail.gmail.com>
	 <courier.47A8497B.0000472E@hawking.rebel.net.au>
	 <1202240590.15090.119.camel@violet>  <47AB0A76.3000404@davidnewall.com>
	 <1202411113.15090.263.camel@violet>  <47ABD317.5060805@davidnewall.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 10:15:01 +0100
Message-Id: <1202462101.15090.300.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> >>>>> I think you're missing my point: as long as the license stays the way
> >>>>> it is now, you can never distribute proprietary code unless you've
> >>>>> consulted a lawyer and even then you run the risk of being sued for
> >>>>> infringement if the copyright holder thinks what you have is derived
> >>>>> work.
> >>>>>       
> >>>>>           
> >>>> Yes I can, if the proprietary code is not linked with GPL code (and the 
> >>>> proprietary code is original).  Loadable modules are not linked.  This is a 
> >>>> very clear-cut case.
> >>>>     
> >>>>         
> >>> that is not clear-cut case. You link at run-time. Otherwise the module
> >>> would do nothing.
> >>>       
> >> That's why it's allowed.  The module isn't linked when it's distributed,
> >> and the author doesn't do or cause the linking; the user does.  And the
> >> user never distributes in the linked state.  Distribution is key to GPL.
> >>     
> >
> > so how do you build this module that is not linked without using the
> > Linux kernel.
> You could hand code in assembler, using Microsoft's assembler under
> Windows.  You could compile from C, using GCC on FreeBSD.  But that's
> immaterial.  A module which is an original, non-derivative work, is,
> well, original and non-derivative.  Do you say that it must be
> otherwise?  Why would that be?

since when does the language make any difference.

Anyway you are still under the impression that a Linux kernel module can
be original work in the end. We keep telling you that could be a wrong
assumption which is based on the view of many of the kernel developers
and of most of the lawyers that looked at this specific topic.

Let me repeat this. Ask a legal counsel before you go ahead with your
assumption. You might get away with it or you might not. What Greg, Alan
and I try to tell you is that using EXPORT_SYMBOL or EXPORT_SYMBOL_GPL
will create derivative work, but if you don't wanna believe us, that is
your prerogative. So go ahead, but don't complain if you actually get
sued for copyright infringement at some point and tell the court you
didn't know.

And while you are talking to a lawyer. Ask him/her if it is okay to
create a binary only application that uses a GPL library. Tell him/her
that it is original work. Good luck :)

Regards

Marcel


