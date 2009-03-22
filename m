Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZCVScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZCVScU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZCVScD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 14:32:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38556 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZCVScB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 14:32:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49C68424.9080204@s5r6.in-berlin.de>
Date: Sun, 22 Mar 2009 19:32:04 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] A few cleanups for tip-latest
References: <1237741871-5827-1-git-send-email-dmitri.vorobiev@movial.com>
In-Reply-To: <1237741871-5827-1-git-send-email-dmitri.vorobiev@movial.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev wrote:
> Hi Ingo,
> 
> The following three patches are against the latest tip. Please consider.

You called the patches
Fix a couple of sparse warnings in arch/x86/kernel/apic/io_apic.c
Fix one sparse warning in kernel/extable.c
trace: fix four sparse warnings

Better would have been to tell in the headline what the patches fix in
particular.  The fact that the issues were found using the static
checker sparse is of lesser interest and is documented in the changelog
anyway.  For example:
x86: io_apic: make a needlessly global symbol static; clean up 0/NULL
initialization
kernel: exceptions: add missing include
kernel: trace: make a needlessly global symbol static; add missing include

-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
