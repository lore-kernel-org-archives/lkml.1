Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYCIVcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYCIVcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYCIVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:31:52 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:6165 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYCIVbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:31:52 -0400
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       heukelum@fastmail.fm
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
References: <20080309200103.GA895@mailshack.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2008 22:31:49 +0100
In-Reply-To: <20080309200103.GA895@mailshack.com>
Message-ID: <87myp7zire.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 21:25:18.0715 (UTC) FILETIME=[12E3CCB0:01C8822C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum <heukelum@mailshack.com> writes:
> 
> Benchmark using: gcc -fomit-frame-pointer -Os. For each bitmap size 
> 1...512, for each possible bitmap with one bit set, for each possible 
> offset: find the position of the first bit starting at offset. If you 
> follow ;). Times include setup of the bitmap and checking of the 
> results.

BTW another comment: it would be far more sense if you did 
some profiling on what bitmap sizes a real kernel uses
(should be easy enough with some systemtap) and benchmarked
only that.

I doubt 1 bit bitmap searches are common for example ...

-Andi
