Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZKRKk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZKRKk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZKRKk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:40:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36750 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbZKRKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:40:57 -0500
To: Li Yang <leoli@freescale.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [RFC] char/mem: Honor O_SYNC over intelligent setting of uncached access
From: Andi Kleen <andi@firstfloor.org>
References: <1258531548-5015-1-git-send-email-leoli@freescale.com>
Date: Wed, 18 Nov 2009 11:41:01 +0100
In-Reply-To: <1258531548-5015-1-git-send-email-leoli@freescale.com> (Li Yang's message of "Wed, 18 Nov 2009 16:05:48 +0800")
Message-ID: <873a4c5d4y.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Yang <leoli@freescale.com> writes:

D> The original code will automatially set the page non-cacheable if the mmap'ped
> address is not in kernel managed low memory.
>
> We already have O_SYNC flag to pass the cacheability settings.   Therefore we should
> honor the case that O_SYNC is delibrately not used.  For example, it is useful to the
> case that not all system memory is managed by Linux, and want to be mmaped cacheable.
>
> Not sure if there is anything out there depending on the previous behavior.

Very likely there is. That change seems rather dangerous.

If you wanted to do something like this you would need a long 
deprecation period with printks and format warnings. But most likely
it's not worth it, what advantage does the change have?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
