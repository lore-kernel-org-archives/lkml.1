Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYCVKEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYCVKEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 06:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYCVKEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 06:04:37 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:48689 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbYCVKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 06:04:36 -0400
To: Allan Menezes <amenezes007@sympatico.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HPL benchmarking linux kernel for shared memory performance.
References: <47E48575.7040009@sympatico.ca>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Mar 2008 11:04:32 +0100
In-Reply-To: <47E48575.7040009@sympatico.ca>
Message-ID: <87ve3fgjm7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Mar 2008 09:57:56.0655 (UTC) FILETIME=[34139BF0:01C88C03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allan Menezes <amenezes007@sympatico.ca> writes:

> from filling the register EAX with values above 0x03
> So I was seeing only 2 cores for a quad core in cat /proc/cpuinfo on
> all nodes giving me lousy performance for every kernel except some
> like 2.6.23.13 and 2.6.23.14.

You say some older kernels behaved better than newer ones in the two
core oversub configuration? That would be still an issue that should
be investigated.  After all Linux should run well even with
oversubscribing on two cores.

-Andi
