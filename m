Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbXDKPsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbXDKPsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXDKPsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:48:35 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:43350 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXDKPsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:48:33 -0400
Date: Wed, 11 Apr 2007 17:44:40 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
cc: kernel-janitors@lists.osdl.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alan@redhat.com
Subject: Re: [KJ][PATCH] SPIN_LOCK_UNLOCKED cleanup in drivers/ata/pata_winbond.c
In-Reply-To: <20070411152846.GA11449@arun.site>
Message-ID: <Pine.LNX.4.61.0704111744080.32056@yvahk01.tjqt.qr>
References: <20070411152846.GA11449@arun.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 20:58, Milind Arun Choudhary wrote:
>
>remove SPIN_LOCK_UNLOCKED, use DEFINE_SPINLOCK instead

Don't we have some more places where spinlocks could be janitorified?
Otherwise, ok!


Jan
-- 
