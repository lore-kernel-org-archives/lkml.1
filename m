Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZFXIvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZFXIvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZFXIvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:51:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34041
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbZFXIvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:51:22 -0400
Date: Wed, 24 Jun 2009 01:51:26 -0700 (PDT)
Message-Id: <20090624.015126.193707604.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090624075342.GL6760@one.firstfloor.org>
References: <20090624071555.GK6760@one.firstfloor.org>
	<20090624.001729.155964457.davem@davemloft.net>
	<20090624075342.GL6760@one.firstfloor.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 24 Jun 2009 09:53:42 +0200

>> > Ah you have a one shot timer and it gets rescheduled in the softirq?
>> > If yes why not in doing that directly in the hardirq handler?
>> 
>> Then what's the point of the generic timer code supporting one-shot
>> clock sources? :-)
> 
> Well it would avoid that problem at least (I think based on your
> description). Somehow you need to reschedule the timer before the softirq.
> 
> I guess you could have a generic function that is callable from hardirq
> directly?

I'll think a bit more about this, thanks Andi.
