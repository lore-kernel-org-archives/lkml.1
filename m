Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYHTKBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYHTKBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYHTKBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:01:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49245 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYHTKBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:01:01 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg Donald <gdonald@gmail.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: INFO: task reiserfs/0:1322 blocked for more than 120 seconds
From: Andi Kleen <andi@firstfloor.org>
References: <15e66e4e0808162136r2a439ee9wbb20f2b1f8fabc77@mail.gmail.com>
	<20080819235258.fa775505.akpm@linux-foundation.org>
	<20080820091918.GB23865@elte.hu>
Date: Wed, 20 Aug 2008 12:00:59 +0200
In-Reply-To: <20080820091918.GB23865@elte.hu> (Ingo Molnar's message of "Wed, 20 Aug 2008 11:19:18 +0200")
Message-ID: <87abf8ypic.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> ok. How about quadrupling the timeout, as per the patch below?
>
> more than 8 minutes uninterruptible wait, is that a reasonable limit?

There should be a way to disable them for NFS and other network
file systems at least. Having network issues is not that uncommon
and flooding the log with backtraces every time they happen
when a network fs is mounted is not very useful.

-Andi

