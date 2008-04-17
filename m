Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbYDQKMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbYDQKMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758862AbYDQKMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:12:18 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:11352 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463AbYDQKMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:12:17 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
From: Andi Kleen <andi@firstfloor.org>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
	<20080417021813.04df7912.akpm@linux-foundation.org>
	<20080417093025.GA17389@elte.hu>
	<20080417023603.672d1032.akpm@linux-foundation.org>
Date: Thu, 17 Apr 2008 12:11:36 +0200
In-Reply-To: <20080417023603.672d1032.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 17 Apr 2008 02:36:03 -0700")
Message-ID: <87zlrshjtz.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Apr 2008 10:04:49.0323 (UTC) FILETIME=[78C93FB0:01C8A072]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Does it really really really need to consume one of our few remaining page
> flags?  We'll be in a mess when we run out.

No we're not. Just the (imho always misguided) "encode zone/node number 
into flags" optimization has to be removed again or made 64bit only.
Then there will be plenty of flags again.

Really I see no real reason this can't be done with a small hash table
again like x86-64 originally did.

-Andi
