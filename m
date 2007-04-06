Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbXDFXem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbXDFXem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXDFXem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:34:42 -0400
Received: from smtp102.sbc.mail.re2.yahoo.com ([68.142.229.103]:25436 "HELO
	smtp102.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751722AbXDFXel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:34:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Wz29pVeCIGK3hGZK9DlZ8vb3yP5Oeu40QQKNxshgsq8pQpLF8ORgHpOpXtlesx0lcHG+3ksU/v8VUgPko7DPSzhTz0uhoFIy4/H8SsLM/z4v+zq32mVDUOiq/KoE516z/Ip+3p0hK+Gil7CZIpEz29Dsbwffc1naSqxhzBx9MrQ=  ;
X-YMail-OSG: jewK2LoVM1n6ql21i7iUDvTiYeZEcfaOtfOvSHADSexX8pP6
From: David Brownell <david-b@pacbell.net>
To: tglx@linutronix.de
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
Date: Fri, 6 Apr 2007 16:34:38 -0700
User-Agent: KMail/1.7.1
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <200704061557.12662.david-b@pacbell.net> <1175901682.28263.507.camel@localhost.localdomain>
In-Reply-To: <1175901682.28263.507.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061634.39344.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 4:21 pm, Thomas Gleixner wrote:
> David,
> 
> On Fri, 2007-04-06 at 15:57 -0700, David Brownell wrote:
> > This particular issue doesn't actually affect indentation, since the
> > tab trumps that space.  So it's a bit off-agenda for this particular
> > flamage.
> 
> ROTFL, the tab trumps the space. Is this a card game ?

Nah, just standard display algorithms.  Alignment doesn't change.


> > > Please change your coding style to conform to Documentation/CodingStyle.
> > > 
> > >       ***     Only indent with tabs!!         ***
> 
> How does your own rule make SPACE-TAB-TAB more acceptable than
> TAB-TAB-SPACE ? Just because TAB trumps the space but not the other way
> round ?

Because when you display the text, it doesn't affect the
alignment == indentation.  In fact you have to turn on
nonstandard editor options to even see if this happened.
Not everyone does so, which is why such things persist.

So in practical terms "\n \t" and "\n\t" are identical;
although the former "should not" be used, it doesn't
actually affect what CodingStyle is primarily trying to
control (i.e. what the code looks like).


> You started nitpicking, so please accept the backfire.

Done.

:)
