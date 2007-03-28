Return-Path: <linux-kernel-owner+w=401wt.eu-S933786AbXC1XlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbXC1XlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933834AbXC1XlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:41:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933786AbXC1XlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:41:13 -0400
Date: Thu, 29 Mar 2007 01:41:10 +0200
From: Karel Zak <kzak@redhat.com>
To: Tomas M <tomas@slax.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max_loop limit
Message-ID: <20070328234110.GL27806@petra.dvoda.cz>
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com> <Pine.LNX.4.61.0703230232320.9555@yvahk01.tjqt.qr> <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr> <4606356A.7070403@slax.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4606356A.7070403@slax.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 10:40:10AM +0200, Tomas M wrote:
> >here's one. Allocates all the fluff dynamically. It does not create any
> >dev nodes by itself, so you need to do it (à la mdadm)
> 
> I'm afraid that this would break a lot of things, for example mount -o 
> loop will not work anymore unless you create /dev/loop* manually first, 

 Yes, "losetup" and "mount -o loop" call stat( /dev/loopN ) when look
 for an (un)used loop device.

> am I correct? In this case, this is unusable for many as it is not 
> backward compatible with old loop.c, am I correct?

 udev ?

        Karel

-- 
 Karel Zak  <kzak@redhat.com>
