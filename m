Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbYJNQDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbYJNQDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYJNQDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:03:15 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:30188 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYJNQDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:03:13 -0400
X-BigFish: VPS-45(z5edJz62a3L146fK1432R98dR936eQ4015M1805Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8QKJ9-01-XTB-01
Date: Tue, 14 Oct 2008 18:01:48 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Please pull arch perfmon update
Message-ID: <20081014160148.GA1029@erda.amd.com>
References: <20080929235253.GA31074@one.firstfloor.org> <20081013183556.GD23557@erda.amd.com> <48F3AFBF.3040201@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48F3AFBF.3040201@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Oct 2008 16:02:02.0333 (UTC) FILETIME=[323608D0:01C92E16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.10.08 22:29:51, Andi Kleen wrote:
> > There is one question to patch "oprofile: discover counters for op
> > ppro too". arch_perfmon_setup_counters() is actually never called for
> > ppro, so there is no code that changes the numbers in
> > op_ppro_spec. The patch as it is has no effect (except then loading
> > additional module code).
> 
> Ah true, i must have deleted one hunk too much while refactoring.
> It's ok to drop this patch for now.

I sent it upstream anyway, please send an additional patch that fixes
this.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

