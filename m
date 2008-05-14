Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYENWRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYENWRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYENWRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:17:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbYENWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:17:15 -0400
Date: Wed, 14 May 2008 15:16:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
In-Reply-To: <87bq387cyn.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0805141515020.3019@woody.linux-foundation.org>
References: <20080514174955.GA515@elte.hu> <6457.1210801515@vena.lwn.net> <87bq387cyn.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 May 2008, Andi Kleen wrote:
>
> The goal less being to get rid of BKL in old drivers, but not 
> requiring BKL in new drivers. Basically all BKL assumptions
> in interfaces really should go.

No, we really do want to get rid of BKL in old drivers too. Or at least in 
the interfaces.

		Linus
