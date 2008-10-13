Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYJMF6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYJMF6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 01:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYJMF6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 01:58:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37263 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYJMF6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 01:58:46 -0400
To: Hans Schou <linux@schou.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SiS55x, another x86 CPU
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk>
Date: Mon, 13 Oct 2008 07:58:41 +0200
In-Reply-To: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk> (Hans Schou's message of "Sat, 11 Oct 2008 23:24:42 +0200 (CEST)")
Message-ID: <87d4i5rq7i.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Schou <linux@schou.dk> writes:


> flags           : fpu tsc cx8 mmx
>
> Instruction and data cache is 8KB each it says in the datasheet. I'm
> not sure but it does not look like it is written in dmesg.
>
> ACPI sleep supports S1 S2 S3 S4 S5.
>
> CPU power states supports C0 C1 C2 C3.
>
> See attachment. (I hope it gets here!)

Your attachment seems to be windows line end damaged.
Also the changes are so small that it's not worth adding a CONFIG
for it. Just add it unconditionally.
And hardcoding the cache size for all of SiS seems a bit extreme.
What happens when SiS ever brings out another part with different caches?
Ideally figure out some way to detect this particular CPU and only
use 8 KB only for that. Alternatively ignore it (there's nothing
really in the kernel that uses the cache sizes anyways)

-Andi

