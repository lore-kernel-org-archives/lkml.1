Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbYJNOG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbYJNOG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbYJNOGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:06:20 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:37874 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYJNOGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:06:20 -0400
X-BigFish: VPS-37(z5edJz62a3L1432R98dR936eQ1805Mzzzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K8QF61-01-QZB-01
Date: Tue, 14 Oct 2008 16:05:50 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Please pull arch perfmon update
Message-ID: <20081014140549.GG23557@erda.amd.com>
References: <20080929235253.GA31074@one.firstfloor.org> <20081013183556.GD23557@erda.amd.com> <48F3AFBF.3040201@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48F3AFBF.3040201@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Oct 2008 14:06:03.0755 (UTC) FILETIME=[FE934BB0:01C92E05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.10.08 22:29:51, Andi Kleen wrote:
> > I added a follow on patch (446223f) on branch arch-perfmon that
> 
> I didn't do that intentionally because it's called too late.
> The function really has to be called early, so that the fallback
> works.

The hook is in op_nmi_init() and directly called after
arch_perfmon_init() and before init_sysfs(). Only
register_cpu_notifier() and the setup of oprofile_operations are in
between. This should work.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

