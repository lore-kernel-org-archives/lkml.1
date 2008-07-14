Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbYGNShf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbYGNShf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbYGNShK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:37:10 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:20121 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbYGNShJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:37:09 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
From: Andi Kleen <andi@firstfloor.org>
References: <20080714144828.GA22666@elte.hu>
	<alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org>
Date: Mon, 14 Jul 2008 20:35:05 +0200
In-Reply-To: <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> (Linus Torvalds's message of "Mon, 14 Jul 2008 08:03:16 -0700 (PDT)")
Message-ID: <871w1wz546.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jul 2008 18:35:05.0424 (UTC) FILETIME=[55C18500:01C8E5E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> Why not pick something that is *guaranteed* to fault? The above looks like 
> any future setup that supports 41 bits of addressing and has extended the 
> page tables (yes, it will happen eventually) will find that to be a 
> perfectly valid address?

When that happens then it will be either unmapped (and fault anyways)
or the kernel has to be changed to 5 level page tables first and then 
surely the poison value could change too.

-Andi
