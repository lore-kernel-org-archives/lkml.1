Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbYFJEHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbYFJEHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 00:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbYFJEHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 00:07:24 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:33106 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYFJEHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 00:07:20 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, holt@sgi.com,
       andrea@qumranet.com
Subject: Re: [patch 01/11] GRU Driver - hardware data structures
From: Andi Kleen <andi@firstfloor.org>
References: <20080609211028.110089743@attica.americas.sgi.com>
	<20080609211044.992972808@attica.americas.sgi.com>
	<20080609155217.97806364.akpm@linux-foundation.org>
Date: Tue, 10 Jun 2008 06:07:17 +0200
In-Reply-To: <20080609155217.97806364.akpm@linux-foundation.org> (Andrew Morton's message of "Mon, 9 Jun 2008 15:52:17 -0700")
Message-ID: <871w36q6fe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jun 2008 04:00:06.0298 (UTC) FILETIME=[77CB1FA0:01C8CAAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> +#if defined __ia64__
>> +#elif defined __x86_64__
>> +#endif
>
> CONFIG_IA64 and CONFIG_X86_64 would be more fashionable.

These ifdefed parts should probably be all in asm-*/gru.h

-Andi
