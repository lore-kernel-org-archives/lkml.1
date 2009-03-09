Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZCIQqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZCIQqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZCIQpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:45:55 -0400
Received: from dns2.vpop.net ([216.193.240.3]:2604 "EHLO thorin.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZCIQpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:45:54 -0400
X-Greylist: delayed 1340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 12:45:54 EDT
Message-ID: <49B5427E.6000107@vpop.net>
Date: Mon, 09 Mar 2009 09:23:26 -0700
From: Matt Reimer <mreimer@vpop.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: linux-kernel@vger.kernel.org, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] ds2760_battery.c: fix division by zero
References: <1236614002-9102-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1236614002-9102-1-git-send-email-daniel@caiaq.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> The 'battery remaining capacity' calculation in
> drivers/power/ds2760_battery.c lacks a parameter check to a division
> operation which causes the kernel to oops on my board.
>   
Signed-off-by: Matt Reimer <mreimer@vpop.net>

Matt
