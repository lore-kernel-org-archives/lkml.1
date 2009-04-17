Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbZDQLYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbZDQLYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760771AbZDQLYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:24:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50529 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760762AbZDQLYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:24:40 -0400
Message-ID: <49E866E0.2090007@jp.fujitsu.com>
Date: Fri, 17 Apr 2009 20:24:16 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [22/28] x86: MCE: Default to panic timeout for machine
 checks
References: <20090407507.636692542@firstfloor.org> <20090407150805.588AA1D046D@basil.firstfloor.org>
In-Reply-To: <20090407150805.588AA1D046D@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Fatal machine checks can be logged to disk after boot, but only if
> the system did a warm reboot. That's unfortunately difficult with the
> default panic behaviour, which waits forever and the admin has to
> press the power button because modern systems usually miss a reset button.
> This clears the machine checks in the registers and make
> it impossible to log them.
> 
> This patch changes the default for machine check panic to always
> reboot after 30s. Then the mce can be successfully logged after
> reboot.

In case if user already set panic_timeout to 5s, the that user need to
wait extra 25s for machine check panic... ?

The idea is good, but I think some switch like "no_reboot_on_mce" would
be required.


Thanks,
H.Seto

