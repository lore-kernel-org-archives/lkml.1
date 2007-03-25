Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbXCYIkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbXCYIkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 04:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbXCYIkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 04:40:15 -0400
Received: from hosting4p.com ([81.0.235.160]:48243 "EHLO micron1.hosting4p.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753488AbXCYIkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 04:40:14 -0400
Message-ID: <4606356A.7070403@slax.org>
Date: Sun, 25 Mar 2007 10:40:10 +0200
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max_loop limit
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com> <Pine.LNX.4.61.0703230232320.9555@yvahk01.tjqt.qr> <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> here's one. Allocates all the fluff dynamically. It does not create any
> dev nodes by itself, so you need to do it (à la mdadm)

I'm afraid that this would break a lot of things, for example mount -o 
loop will not work anymore unless you create /dev/loop* manually first, 
am I correct? In this case, this is unusable for many as it is not 
backward compatible with old loop.c, am I correct?


Tomas M
slax.org

