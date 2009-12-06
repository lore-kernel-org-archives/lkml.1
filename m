Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbZLFQXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbZLFQXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 11:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbZLFQXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 11:23:12 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35843 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751AbZLFQXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 11:23:12 -0500
Message-ID: <4B1BDAA3.10601@gentoo.org>
Date: Sun, 06 Dec 2009 08:24:03 -0800
From: Zac Medico <zmedico@gentoo.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090907)
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>,
       linux-kernel@vger.kernel.org, Zac Medico <zmedico@gentoo.org>
Subject: Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>	 <4B055609.9030306@tremplin-utc.net>	 <4B1A53AE.9020707@tremplin-utc.net> <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>
In-Reply-To: <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zeno Davatz wrote:
> Ok, it does compile but when I insert the module I get:
> 
> psb: Unknown symbol i2c_bit_add_bus

This might solve it:

  modprobe i2c_algo_bit

That module comes from CONFIG_I2C_ALGOBIT=m in your kernel config.
-- 
Thanks,
Zac
