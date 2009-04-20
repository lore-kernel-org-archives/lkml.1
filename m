Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZDTHVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZDTHVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZDTHVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:21:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33169 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZDTHVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:21:01 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH -tip 1/3] x86, mce: Revert "add mce_threshold option for intel cmci"
From: Andi Kleen <andi@firstfloor.org>
References: <49EBCDB0.7000505@jp.fujitsu.com>
	<49EBCF58.3030602@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 09:20:57 +0200
In-Reply-To: <49EBCF58.3030602@jp.fujitsu.com> (Hidetoshi Seto's message of "Mon, 20 Apr 2009 10:26:48 +0900")
Message-ID: <87vdozpz8m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:

> After having some discussion with Andi Kleen, we have concluded
> that setting threshold >1 will not work properly.  This patch
> reverts the previous patch that introduces mce_threshold option.
>
> However as Ingo pointed out, cmci is a new feature so having boot
> controls to disable it is generally a good idea, and it might be
> handy if the hw is misbehaving.
>
> So instead of mce_threshold, I will introduce "mce=no_cmci" option
> to support cmci disablement in later patch.
> Compare with mce_threshold, it lacks threshold >1 support but it
> does not matter because it will not work.
>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Andi Kleen <ak@linux.intel.com>

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
