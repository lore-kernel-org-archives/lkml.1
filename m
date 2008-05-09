Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbYEITgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbYEITgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYEITgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:36:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60067 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYEITgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:36:25 -0400
Message-ID: <4824A7B6.70306@firstfloor.org>
Date: Fri, 09 May 2008 21:36:22 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
References: <20080509174148.GA22246@basil.nowhere.org> <482491D6.9030205@grupopie.com>
In-Reply-To: <482491D6.9030205@grupopie.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> ffffffff80337043 u idr_pre_get  [i2c_core]
>> ffffc2000007573e ? DW.sched.h.920090ff.56       [i2c_core]
> 
> Are you compiling with CONFIG_KALLSYMS_ALL?

Yep.

CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set

> If you are, kallsyms will store all the output of "nm -n vmlinux" no
> matter what section the symbol belongs to...

Yes and? Surely that's not correct?

-Andi




