Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZFJReL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZFJReL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZFJRd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:33:58 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38435 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbZFJRd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:33:57 -0400
Date: Wed, 10 Jun 2009 19:33:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
Message-ID: <20090610193312.37b944f3@skybook>
In-Reply-To: <alpine.LFD.2.00.0906092252150.3351@localhost.localdomain>
References: <20090603152223.083010123@de.ibm.com>
	<alpine.LFD.2.00.0906092252150.3351@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 22:52:51 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 3 Jun 2009, Martin Schwidefsky wrote:
> 
> > Greetings,
> > version 2 of the profile patches. The only change is the in_interrupt()
> > fix in tick_nohz_stop_idle(). I would like to know how to proceed with
> > the issue.
> > Andy, do you still prefer to handle the old style profiler analog to
> > the oprofile patch? If yes I would drop patch #1 and extend patch #2
> > with another tick_nohz_disable().
> 
> Any update on this one ?

I haven't heard anything from any Andy in regard to patch #1. We could
do patch #2 now and decide later what we want to do with the old style
profiler.

blue skies,
  Martin.
