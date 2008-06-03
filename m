Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYFCQgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYFCQgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYFCQgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:36:22 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:4886 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbYFCQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:36:21 -0400
To: Jason Yeh <jason.yeh@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Updated: Oprofile Multiplexing
From: Andi Kleen <andi@firstfloor.org>
References: <1212509807.22351.1.camel@pranjaparamita>
Date: Tue, 03 Jun 2008 18:35:33 +0200
In-Reply-To: <1212509807.22351.1.camel@pranjaparamita> (Jason Yeh's message of "Tue, 3 Jun 2008 11:16:47 -0500")
Message-ID: <87bq2iv5m2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Jun 2008 16:28:24.0635 (UTC) FILETIME=[D86568B0:01C8C596]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Yeh <jason.yeh@amd.com> writes:

> This is an updated patch to enable Oprofile module to switch between different
> sets of events at the user specified interval. It allows the module to gather
> more event statistics than the number of event counters on the hardware in a
> single run of profiling.
>
> A new file (/dev/oprofile/timeout_ms) is added for user to specify the interval.

This sounds actually like something that should be handled with hrtimers
for best results and then ms would be not finegrained enough.

-Andi
