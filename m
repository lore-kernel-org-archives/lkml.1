Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYECT1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYECT1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYECT1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:27:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60138
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752635AbYECT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:27:34 -0400
Date: Sat, 03 May 2008 12:27:34 -0700 (PDT)
Message-Id: <20080503.122734.01023096.davem@davemloft.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, efault@gmx.de, elendil@planet.nl,
       parag.warudkar@gmail.com, linux-kernel@vger.kernel.org,
       guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080503101016.GA18801@elte.hu>
References: <20080503082849.GA29605@elte.hu>
	<20080503.020502.226847930.davem@davemloft.net>
	<20080503101016.GA18801@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 3 May 2008 12:10:16 +0200

> ( although please note that the growing generalization that goes on
>   _did_ find a subtle nohz problem on sparc64 early in the merge window,
>   so it's not like these changes are totally useless to you. )

Note that this bug theoretically exists on every platform,
even x86, and only sparc64 is fixed at the moment by adding
the irq_{entry,exit}() guards around all of it's IPI handlers.

Just a reminder.
