Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYLOAK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYLOAK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 19:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYLOAKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 19:10:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51761 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbYLOAKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 19:10:50 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add command line init_start_cpus
From: Andi Kleen <andi@firstfloor.org>
References: <4944A279.5020009@kernel.org>
Date: Mon, 15 Dec 2008 01:11:24 +0100
In-Reply-To: <4944A279.5020009@kernel.org> (Yinghai Lu's message of "Sat, 13 Dec 2008 22:06:49 -0800")
Message-ID: <87myeyfgb7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> Impact: new command line
>
> so could select cpus to be started during init stage

maxcpus=N should do this already, at least for the first N cpus.
If you really need a non continuous range of N (why?) then it would
be better to fix maxcpus instead of adding a new option.

-Andi

-- 
ak@linux.intel.com
