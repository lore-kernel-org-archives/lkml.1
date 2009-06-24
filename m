Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZFXHxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZFXHxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZFXHxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:53:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52472 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZFXHxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:53:39 -0400
Date: Wed, 24 Jun 2009 09:53:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
Message-ID: <20090624075342.GL6760@one.firstfloor.org>
References: <20090624070315.GH6760@one.firstfloor.org> <20090624.000811.118222188.davem@davemloft.net> <20090624071555.GK6760@one.firstfloor.org> <20090624.001729.155964457.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624.001729.155964457.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ah you have a one shot timer and it gets rescheduled in the softirq?
> > If yes why not in doing that directly in the hardirq handler?
> 
> Then what's the point of the generic timer code supporting one-shot
> clock sources? :-)

Well it would avoid that problem at least (I think based on your
description). Somehow you need to reschedule the timer before the softirq.

I guess you could have a generic function that is callable from hardirq
directly?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
