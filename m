Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZGOSNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZGOSNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbZGOSNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:13:42 -0400
Received: from gandalf.vpop.net ([216.193.240.4]:51654 "EHLO gandalf.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbZGOSNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:13:42 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 14:13:42 EDT
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Anton Vorontsov <cbou@mail.ru>
Message-Id: <4E87138F-3AF0-461E-A7A5-A71FCC1B5C70@vpop.net>
From: Matt Reimer <mreimer@vpop.net>
To: Daniel Mack <daniel@caiaq.de>
In-Reply-To: <1247674841-9909-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 1/4] ds2760: delay power supply registration
Date: Wed, 15 Jul 2009 11:05:53 -0700
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 15, 2009, at 9:20 AM, Daniel Mack wrote:

> This fixes a race condition I recently introduced with the PMOD  
> feature
> addition (cef437e3: "w1: ds2760_battery: add support for sleep mode
> feature").
>
> Postpone the call to power_supply_register() to fix it.
>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> Cc: Matt Reimer <mreimer@vpop.net>
> Cc: Anton Vorontsov <cbou@mail.ru>

Acked-by: Matt Reimer <mreimer@vpop.net>

Matt
