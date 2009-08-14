Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbZHNQfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbZHNQfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 12:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbZHNQfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 12:35:17 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:64763 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932263AbZHNQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 12:35:16 -0400
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.31-rc6, BTRFS] potential memory leaks...
References: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 14 Aug 2009 17:35:07 +0100
In-Reply-To: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com> (Daniel J. Blueman's message of "Fri\, 14 Aug 2009 16\:03\:04 +0100")
Message-ID: <tnxab228ibo.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Aug 2009 16:35:09.0447 (UTC) FILETIME=[30339170:01CA1CFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> There is good chance that the BTRFS kmemleak reports using 2.6.31-rc6
> [1] are false-positives, due to the overwriting of the static pointers
> [2]. Does this ring true with anyone else?

If you do a few echo scan > /sys/kernel/debug/kmemleak, do they
disappear?

The static pointers are scanned by kmemleak, unless they are in the
.data.init section (which is removed anyway).

-- 
Catalin
