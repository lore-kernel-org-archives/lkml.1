Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZGGKr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZGGKr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZGGKrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:47:18 -0400
Received: from mail.anarazel.de ([217.115.131.40]:42924 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbZGGKrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:47:16 -0400
From: Andres Freund <andres@anarazel.de>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( possibly?caused by netem)
Date: Tue, 7 Jul 2009 12:47:16 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc1-andres-00457-g396ca83-dirty; KDE/4.2.95; x86_64; ; )
Cc: Jarek Poplawski <jarkao2@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <200907031326.21822.andres@anarazel.de> <20090707065014.GA3296@ami.dom.local> <a5d9929e0907070340y63280508t92e6c7e4ce464994@mail.gmail.com>
In-Reply-To: <a5d9929e0907070340y63280508t92e6c7e4ce464994@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907071247.16977.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009 12:40:16 Joao Correia wrote:
> I am now running 2.6.31-rc2 for a couple of hours, no freeze.
>
> Let me know what/if i can help with tracking down the original source
> of the problem.
You dont see the problem anymore with the `echo 0 > 
/proc/sys/kernel/timer_migration`  change (or equivalently with the patch from 
Jarek) or has the problem vanished completely?

Andres
