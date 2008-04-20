Return-Path: <linux-kernel-owner+w=401wt.eu-S1760413AbYDTSxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbYDTSxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbYDTSxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:53:44 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:7831 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbYDTSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:53:43 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: remove unused code and data in nexgen.c
From: Andi Kleen <andi@firstfloor.org>
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
	<1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>
	<480AC505.1030301@zytor.com>
Date: Sun, 20 Apr 2008 20:51:56 +0200
In-Reply-To: <480AC505.1030301@zytor.com> (H. Peter Anvin's message of "Sun, 20 Apr 2008 00:22:29 -0400")
Message-ID: <877ies9x6b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 18:45:08.0879 (UTC) FILETIME=[A854B1F0:01C8A316]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Dmitri Vorobiev wrote:
>> Nobody calls the function nexgen_init_cpu(), therefore it
>> can be removed. The variable nexgen_cpu_dev is used only by
>> this function, so this patch removes useless data as well.
>> This patch was build-tested using defconfigs for i386 and x86_64.
>> It also survived a few randconfig instances for i386. Runtime
>> tests were performed by booting 32-bit and 64-bit x86 boxen up to
>> the shell prompt.
>
> NAK.  This is broken.
>
> The reason nexgen_cpu_dev is unreferenced is because the file is
> missing a cpu_vendor_dev_register(), which should be added.

If we did that long without it wouldn't it be better to just remove it?

Also NexGen was never shipped anyways, but bought by AMD and became
the K6. So I assume whatever this file is supposed to do is done
by amd.c anyways.

-Andi
