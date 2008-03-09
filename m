Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYCIV3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYCIV3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYCIV3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:29:42 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:6020 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbYCIV3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:29:41 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
References: <20080309200103.GA895@mailshack.com>
	<20080309201152.GB28454@elte.hu>
	<1205094704.6430.1241420859@webmail.messagingengine.com>
	<20080309205132.GA9021@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2008 22:29:39 +0100
In-Reply-To: <20080309205132.GA9021@elte.hu>
Message-ID: <87r6ejziv0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 21:23:07.0939 (UTC) FILETIME=[C4F0F730:01C8822B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> ok - but this needs to be solved in a cleaner way. That build-time 
> optimization needs to be pushed into generic code so that 32-bit x86 and 

It probably doesn't make sense in generic code because it will be 
too large open coded.

-Andi


