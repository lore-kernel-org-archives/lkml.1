Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYKQSPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYKQSPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYKQSPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:15:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49907 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYKQSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:15:46 -0500
Date: Mon, 17 Nov 2008 19:25:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
Message-ID: <20081117182527.GO6703@one.firstfloor.org>
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com> <20081110154948.GW29626@one.firstfloor.org> <4919430C.6050502@cosmosbay.com> <20081117173359.GI1664@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117173359.GI1664@erda.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 06:33:59PM +0100, Robert Richter wrote:
> On 11.11.08 09:32:12, Eric Dumazet wrote:
> 
> [...]
> 
> > PATCH] oprofile: un-mask APIC before resetting counter in ppro_check_ctrs()
> 
> Is this the patch you all prefer? If so, I would like to send it
> upstream.

It would be better to root cause the problem first.

I worked with Eric privately and tried a few things, but didn't help
so far. Most likely the workaround is also not complete before
it is fully understood. Not sure how long this will take though.

It's probably ok as a workaround for a release, but shouldn't 
be considered a final fix.

-Andi

