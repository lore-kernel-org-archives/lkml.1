Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXD1Los@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXD1Los (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbXD1Los
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:44:48 -0400
Received: from web36707.mail.mud.yahoo.com ([209.191.85.41]:22327 "HELO
	web36707.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756270AbXD1Lor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:44:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3M5gqgsxNaS8IvYF6OGJ32K5bmOjgYiF1XG9vm28x6iv1iMMye1rqC+ltUrgkxzjpqtFg4Q9I4uK66BDiZeXFBHE/2c5nBkcCS+DNDVAf1qSDb5AYtqtAknzQPgowitLogMpotO062lixjfx/hbsIr+krj246UflkCQjfV3v1pI=;
X-YMail-OSG: kJ3drTkVM1k28arzQ226QOOh.P7pqfS8ahPtkzlEqATH7U9IIgqpkDdF.uZdSDnQ6rkU2ZwNZTtlcemVu9EGgR487eLCWKFfcwLwhalPqQrPBSVAn._s9IMQoeAHbA--
Date: Sat, 28 Apr 2007 04:44:46 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
To: Sergey Yanovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-list@drzeus.cx>
In-Reply-To: <4633315E.8060807@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <257974.51495.qm@web36707.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> Sergey Yanovich wrote:
> > I have compiled v2.6.21 with git-mmc.patch of v2.6.21-rc7.mm2.
> > After [tifm_sd] is loaded. My smoke test script at
> > 
> > http://bugzilla.kernel.org/attachment.cgi?id=11240&action=view
> > 
> > reliably hangs suspend.
> 
> I really wish you would stop removing me from cc...
> 
> Suspend is broken in -mm for all controllers. There is a bit of a race between
> the resume and remove functions that causes things to deadlock. I have a fix,
> but I'm working on pushing a lot of stuff to Linus right now so it might take a
> few days before things hit the repos.
> 

I prepared a tarball with 2.6.21 compatible driver (tifm-0.8e on berlios). I don't see any
problems on stock 2.6.21.1. You may want to test it on your machine.


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
