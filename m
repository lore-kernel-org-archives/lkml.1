Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbXDFVTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbXDFVTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933054AbXDFVTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:19:16 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:41458 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933041AbXDFVTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:19:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1kAuzLECWerDvR/Af+pswxzhI25Zkv+M2rcSBH+F9uNk+4ga2q4zNeFw8SU+YEAmBvJCMfmShPxT0OV9eHLQA/p1cn40hIjwM3+uMINCB6HOTgcE+R1gZqP8gJW0C5/9aky0q2jo2w1GAINZeKSOAyniPMVyD7gkPYQikdhr0Zk=  ;
X-YMail-OSG: N_U9AKYVM1ncVuhRXwLd1BgH1yyxXCMOBZg81WCrwTSrzun2gPKTCALQYJ2pNksxunP8E9oOlQ--
From: David Brownell <david-b@pacbell.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
Date: Fri, 6 Apr 2007 13:57:03 -0700
User-Agent: KMail/1.7.1
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <200704061029.55710.david-b@pacbell.net> <Pine.LNX.4.61.0704061951580.6042@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704061951580.6042@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061357.03700.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 12:16 pm, Jan Engelhardt wrote:
> >> and that the inner block code 
> >> (lines 3 and 4) should have more indent than line 2.
> >
> >We disagree.  The "inner" block should in all cases have one-tab indent.
> 
> You disagree. "We", as in, the kernel coders,

... agree with what I said, since that's exactly what CodingStyle says,
and what essentially every line of kernel code does today.  (There are
random spots of brokenness, but they get fixed over time.)


> though I do not speak for 
> them, seem to do it much the way I described, judging from the code they
> wrote/write.

Your eyes are broken then ... or maybe you're focussing exclusively
on code that violates the most basic coding guidelines like:

	if (...) {
		THAT WAS ONE MORE TAB
	}

and

	for (...) {
		THAT WAS ALSO ONE MORE TAB
	}

Come on, stop wasting everyone's time with utter nonsense.

	- Indent always uses tabs
	- When breaking long lines (including long conditions)
		* STILL indent with tabs
		* ... and more than one, to be "substantially" more indented

That's what Documentation/CodingStyle says **TODAY** so stop with the flamage.



