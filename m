Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZGGQLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZGGQLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZGGQLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:11:32 -0400
Received: from mail.anarazel.de ([217.115.131.40]:42322 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbZGGQLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:11:31 -0400
From: Andres Freund <andres@anarazel.de>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( possibly?caused by netem)
Date: Tue, 7 Jul 2009 18:11:27 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc2-andres-00151-gf3060b0; KDE/4.2.95; x86_64; ; )
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <200907031326.21822.andres@anarazel.de> <200907071534.07619.andres@anarazel.de> <20090707135742.GB6798@ami.dom.local>
In-Reply-To: <20090707135742.GB6798@ami.dom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907071811.27570.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009 15:57:42 Jarek Poplawski wrote:
> On Tue, Jul 07, 2009 at 03:34:07PM +0200, Andres Freund wrote:
> ...
> > Testing wether its triggerable inside a vm might be interesting...
> Probably similarly to testing without this patch or even less. Maybe
> I should've warned you but this type of bugs in -rc with possible
> memory or stack overwrites might be fatal for your data (at least).
Fortunately all the data on that machine should either be replaceable or 
regularly backuped.

Will test later today if that patch bugs.

Andres
