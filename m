Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbYGNSnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbYGNSnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYGNSnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:43:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbYGNSnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:43:04 -0400
Date: Mon, 14 Jul 2008 11:42:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
In-Reply-To: <871w1wz546.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0807141142121.3305@woody.linux-foundation.org>
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <871w1wz546.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Andi Kleen wrote:
> 
> When that happens then it will be either unmapped (and fault anyways)
> or the kernel has to be changed to 5 level page tables first and then 
> surely the poison value could change too.

You're still ignoring the other point: ffffc.. is much _less_ visually 
obvious than dead0...

			Linus
