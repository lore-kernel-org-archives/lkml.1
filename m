Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYKZNKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYKZNKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYKZNKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:10:43 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:24590 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYKZNKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:10:42 -0500
X-BigFish: VPS-34(zz1432R98dR1805M936fO103dKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KAXZ93-01-G3H-01
Date: Wed, 26 Nov 2008 14:08:53 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] TSC: resync TSCs on AMD cpus
Message-ID: <20081126130853.GA17552@alberich.amd.com>
References: <20081110120606.GA7476@aftab> <20081113102609.GA7173@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081113102609.GA7173@aftab>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 Nov 2008 13:10:18.0041 (UTC) FILETIME=[54231A90:01C94FC8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 11:26:09AM +0100, Borislav Petkov wrote:
> Hi Ingo, hi Thomas,
> 
> any thoughts on this, ACK/NAK?
> 

Hi Ingo, Thomas,

for what it's worth the patch is

Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Tested-by:  Andreas Herrmann <andreas.herrmann3@amd.com>

Please apply it for .29.


Thanks!

Andreas

PS: Do you need an updated patch, which cleanly applies (i.e. w/o
    fuzziness) to current tip/master and an adapted commit message
    including "Impact"?
    (Impact is "ensure TSC can be used as clocksource on AMD family
    10h/11h")


