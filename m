Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYB0UWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYB0UWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbYB0UWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:22:05 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:48211 "EHLO
	QMTA07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754879AbYB0UWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:22:04 -0500
X-Authority-Analysis: v=1.0 c=1 a=Siy3sSQzJz4A:10
 a=bojhYoMd2USPMMK5XVEeMQ==:17 a=D19gQVrFAAAA:8 a=F4He0BBwVSj-kWfn_LQA:9
 a=OMd058dYc6qL45SubqX4F5oVYLgA:4 a=4N9Db7Z2_RYA:10 a=ZaGerQNKEe0A:10
 a=si9q_4b84H0A:10 a=KUJAPYlYduUA:10
From: kelk1@comcast.net (Quel Qun)
To: David Miller <davem@davemloft.net>, marcel@holtmann.org
Cc: tglx@linutronix.de, dwmw2@infradead.org, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, mingo@elte.hu
Subject: Re: [PATCH] bluetooth: delete timer in l2cap_conn_del()
Date: Wed, 27 Feb 2008 20:21:59 +0000
Message-Id: <022720082021.26121.47C5C66700041AAD000066092200751090CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 -------------- Original message ----------------------
From: David Miller <davem@davemloft.net>
> From: Marcel Holtmann <marcel@holtmann.org>
> Date: Wed, 27 Feb 2008 10:55:07 +0100
> 
> > Hi Dave,
> > 
> > > From: Thomas Gleixner <tglx@linutronix.de>
> > > Date: Tue, 26 Feb 2008 09:28:13 +0100 (CET)
> > >
> > >> Delete a possibly armed timer before kfree'ing the connection object.
> > >>
> > >> Solves: http://lkml.org/lkml/2008/2/15/514
> > >>
> > >> Reported-by:Quel Qun <kelk1@comcast.net>
> > >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > >
> > > I'll apply this, thanks Thomas.
> > 
> > can you please wait for a confirmation from Quel that this fixes it.  
> > My ACK is based on that he confirms that it fixes it for sure.
> 
> It doesn't hurt to toss this to Linus now, if it's bogus we
> have tons of time to revert it.

As I said, it prevents the crash, but does not 'fix' my problem, in that I still cannot use the dongle.
--
kk1
