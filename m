Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYHSQrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYHSQrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYHSQrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:47:39 -0400
Received: from mail5.dslextreme.com ([66.51.199.81]:50028 "HELO
	mail5.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750921AbYHSQri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:47:38 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 12:47:37 EDT
Message-ID: <25da0a65dd8a41208a8a0c0a.20080819094057.whnafynlgba@webmail.dslextreme.com>
Date: Tue, 19 Aug 2008 09:40:57 -0700 (PDT)
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
From: juanslayton@dslextreme.com
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Aivils Stoss" <aivils@latnet.lv>, jkosina@suse.cz,
       "lud" <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       linuxconsole-dev@lists.sourceforge.net, linux-input@vger.kernel.org
User-Agent: DSL Extreme Webmail (www.dslextreme.com)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




I have to apologize for my limited knowledge, but mere ignorance never yet
kept a teacher quiet.  I am trying to follow this discussion because
Aivils and I are  basically trying to do the same thing.  In my case I am
presently running 20 keyboards on a 2.6.26 kernel, using an EHCI
controller, and they all work fine.

If I understand your analysis, Aivils' problem is because the UHCI
controllers are too slow.  (I just happened to get lucky with another
controller.)  I am left with two questions.

1.  What if Aivils needs more than 16 keyboards?  (Standard class sizes
here in California run from 20 to about 30.)  Is there any way he can do
this without a faster controller?

2.  What does the bandwidth limitation say about the maximum number of
boards with the EHCI controller?  I modified the kernel evdev.c and
input.c files to raise the maximum events from 32 to 64, but I hadn't
figured in the effects of bandwidth.

> Now if you plugged some of these keyboards into different UHCI
> controllers on the computer, then the problem wouldn't arise.  Each of
> your four UHCI controllers has two ports.  So without using any hubs at
> all, you can plug 8 keyboards into the computer and they will all work.
>
> If you use some extra hubs as well then you can plug four keyboards
> into each controller, allowing you to use 16 keyboards total.
>
> Alan Stern
>
>
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's
> challenge
> Build the coolest Linux based applications with Moblin SDK & win great
> prizes
> Grand prize is a trip for two to an Open Source event anywhere in the
> world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Linuxconsole-dev mailing list
> Linuxconsole-dev@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linuxconsole-dev
>

