Return-Path: <linux-kernel-owner+w=401wt.eu-S1422874AbXBANda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422874AbXBANda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422873AbXBANda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:33:30 -0500
Received: from web52909.mail.yahoo.com ([206.190.49.19]:45110 "HELO
	web52909.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422870AbXBANda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:33:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=dXFJm5A71AvDRdyBq7sQBtJSHuniVPzMVkfsgtOzDtNg8LOnAq5PP0uHIa32jO79Ny75B3Cg6LY2Uy7Gh+WclgnlM82PmlC136QJ6uOw2aMP4eKbbqOBwd2uWR0sItfL76W0WUjlYe7fEUaVVIIjx6Gsbx3B5IZfN3wIwprMm04=;
X-YMail-OSG: WBA9OSUVM1llw1gl5l_zxww4NDXD874omqrtk.x9MHQuR3kKTKvg1ZQsRpsdK7Stay4scOq7QIUaIr2iqvG2i.JPYicxmpR6bH_bnabF8otqj7X02.8DpoP4F3n17aL5P.cCrGdzEBFquA--
Date: Thu, 1 Feb 2007 13:33:28 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: System crash after "No irq handler for vector" linux 2.6.19
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <873148.54754.qm@web52909.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok. I've finally figured out what is going on. The code is race free but the programmer was an
> idiot.

Hi,

Could this IRQ problem account for this bug as well, please? Or is yours strictly a 2.6.19.x
issue?

http://bugzilla.kernel.org/show_bug.cgi?id=7847

I have a dual P4 Xeon box (HT enabled) so there is a lot of scope for IRQ migration. I was playing
WoW when this bug occurred, so there would have been a lot of IRQs needing handling between both
the video and sound cards.

Cheers,
Chris



		
___________________________________________________________ 
What kind of emailer are you? Find out today - get a free analysis of your email personality. Take the quiz at the Yahoo! Mail Championship. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
