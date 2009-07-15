Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbZGOSS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbZGOSS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbZGOSSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:18:44 -0400
Received: from gandalf.vpop.net ([216.193.240.4]:59257 "EHLO gandalf.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbZGOSSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:18:42 -0400
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Anton Vorontsov <cbou@mail.ru>
Message-Id: <147B4C9E-4AE2-4FAD-BC58-7D5D905A1B77@vpop.net>
From: Matt Reimer <mreimer@vpop.net>
To: Daniel Mack <daniel@caiaq.de>
In-Reply-To: <1247674841-9909-4-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 4/4] ds2760: handle full_active_uAh == 0 case correctly
Date: Wed, 15 Jul 2009 11:06:29 -0700
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de> <1247674841-9909-2-git-send-email-daniel@caiaq.de> <1247674841-9909-3-git-send-email-daniel@caiaq.de> <1247674841-9909-4-git-send-email-daniel@caiaq.de>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 15, 2009, at 9:20 AM, Daniel Mack wrote:

> In systems where the battery monitor is not part of the battery pack  
> and
> is hence not bootstrapped with sane values, the full_active_uAh is
> likely to be zero.
>
> Handle that case by defaulting to the rated_capacity information which
> can be passed to the driver using the new module parameter.
>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> Cc: Matt Reimer <mreimer@vpop.net>
> Cc: Anton Vorontsov <cbou@mail.ru>

Acked-by: Matt Reimer <mreimer@vpop.net>

Matt
