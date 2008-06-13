Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbYFMWjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbYFMWjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 18:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYFMWjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 18:39:01 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:20008 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755140AbYFMWjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 18:39:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=011stBh9SMrcgqkydwMzp/4KBfnyqqio3+oHSqlhUrtGuTDBE+jEoDtJ6ZQBuLO/qoqUeau+O/ePTpImKVI9djUETsvN3JXyCXkzUQ6ebVSUNM7WUTV/+MjQGKuC3xnErAyGLvvPcn+H2j+Fm6z9V1FlTs8RHbR4LuE9J6hWpEs=  ;
X-YMail-OSG: cXCaekIVM1mI8zSTAo9Rf2D6lZRTRXO6lagkPX0Kbz7mHd1qiOzFosT9nrOEwEo9jhP5_rUiymDQbU4ZMTLeHWZNiKUJ3.Nj_nD5AB8LF.elXojSswf4YAN2QEs4m_3jjs4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
Date: Fri, 13 Jun 2008 15:38:54 -0700
User-Agent: KMail/1.9.9
Cc: Lior Dotan <liodot@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <200806131343.41213.david-b@pacbell.net> <20080613210257.GA529@elte.hu>
In-Reply-To: <20080613210257.GA529@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806131538.54254.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008, Ingo Molnar wrote:
> 
> 	 Smooth migration via "make oldconfig" 
> is a must, otherwise we'd lose testers and users.

Yes, but "smooth" doesn't mean there's never a need to cope
with kernel updates by running "xconfig" (or whatever).

In my own experience, several times a year I need to go back
and patch up a mess that "oldconfig" made.  Things drop out,
things get added ... it's the things that get *added* without
even a by-your-leave which often seem hardest to fix.


> 	 you might as well think about the other 98% of 
> users who used the old /dev/rtc with old kernels. (not because they 
> wanted to use bad code, but because simply that was the default)

They can continue working just fine with *only* the legacy RTC.
If they stuck with defaults, no problems appear.  (Modulo the
fact that bitrot is setting in.)

The only thing that causes the least hiccup is someone who was
for a while using a bogus (and non-default) configuration.

Given a bogus configuration, how should it be fixed?  There
can be several solutions, and the right answer for one system
will always be the right one for another.  So any approach
that doesn't expect a human to select options sometimes will
be inherently wrong in various cases.

- Dave


