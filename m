Return-Path: <linux-kernel-owner+w=401wt.eu-S1751273AbZCHHVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbZCHHVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 03:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZCHHVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 03:21:33 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:56816 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbZCHHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 03:21:32 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-s390@vger.kernel.org
Subject: Re: [BUG,2.6.28,s390] Fails to boot in Hercules S/390 emulator
Date: Sun, 8 Mar 2009 08:21:28 +0100
User-Agent: KMail/1.9.9
Cc: Roman Zippel <zippel@linux-m68k.org>, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080230.10099.elendil@planet.nl>
In-Reply-To: <200903080230.10099.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903080821.29609.elendil@planet.nl>
X-OriginalArrivalTime: 08 Mar 2009 07:21:30.0455 (UTC) FILETIME=[80756670:01C99FBE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Frans Pop wrote:
> Kernels after 2.6.27 fail to boot in the Hercules S/390 emulator, quite
> early in the boot process:
>      0.141419! Initializing cgroup subsys ns
>      0.141605! Initializing cgroup subsys cpuacct
>      0.142009! Initializing cgroup subsys devices
>      0.180403! cpu: 2 configured CPUs, 0 standby CPUs
>
> I've bisected this to the following commit:
> commit 5cd1c9c5cf30d4b33df3d3f74d8142f278d536b7
> Author: Roman Zippel <zippel@linux-m68k.org>
> Date:   Mon Sep 22 14:42:43 2008 -0700
>     timekeeping: fix rounding problem during clock update
>
> After reverting 5cd1c9c5cf30 and the somewhat related 6c9bacb41c10 on
> top of 2.6.28.7, the system boots OK again.

JFYI, with the same reverts 2.6.29-rc7 boots correctly too.
