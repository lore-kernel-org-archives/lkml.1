Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYGOKO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYGOKO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 06:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYGOKOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 06:14:19 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:28431 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbYGOKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:14:18 -0400
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make memtest support 32bit
From: Andi Kleen <andi@firstfloor.org>
References: <200807150002.28398.yhlu.kernel@gmail.com>
	<200807150003.44497.yhlu.kernel@gmail.com>
Date: Tue, 15 Jul 2008 12:13:03 +0200
In-Reply-To: <200807150003.44497.yhlu.kernel@gmail.com> (Yinghai Lu's message of "Tue, 15 Jul 2008 00:03:44 -0700")
Message-ID: <87lk03xxow.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jul 2008 10:13:02.0934 (UTC) FILETIME=[5DC40F60:01C8E663]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> only support max_low_pfn below...

.... either add a fixmap or document that 32bit memtest will only
test a small fraction of the available memory on systems with >1GB.
In fact with this restriction it seems rather useless.

-Andi
