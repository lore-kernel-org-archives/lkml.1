Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbYJ0S2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbYJ0S2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYJ0S2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:28:31 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:20006 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYJ0S2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:28:30 -0400
X-BigFish: VPS-35(zz62a3L1432R98dR936eQ1805Mzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K9ETYX-02-7GB-01
Date: Mon, 27 Oct 2008 19:27:52 +0100
From: Robert Richter <robert.richter@amd.com>
To: Nick Piggin <npiggin@suse.de>
CC: levon@movementarian.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] oprofile: fix memory ordering
Message-ID: <20081027182752.GF9785@erda.amd.com>
References: <20081023142554.GA22805@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081023142554.GA22805@wotan.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 27 Oct 2008 18:28:15.0114 (UTC) FILETIME=[C690EEA0:01C93861]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.10.08 16:25:54, Nick Piggin wrote:
> Regular bitops don't work as locks on all architectures.
> 
> Also: can use non-atomic unlock as no concurrent stores to the word.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

I applied your patch to oprofile/oprofile-for-tip. Thanks Nick.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

