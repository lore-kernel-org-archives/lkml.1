Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbYGKC1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbYGKC1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 22:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYGKC1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 22:27:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYGKC1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 22:27:34 -0400
Date: Thu, 10 Jul 2008 19:26:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <alpine.LFD.1.10.0807101908330.2936@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807101925200.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org> <20080710224256.AD038154218@magilla.localdomain> <alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
 <20080711005243.ADE90154218@magilla.localdomain> <alpine.LFD.1.10.0807101824150.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807101855020.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807101908330.2936@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Linus Torvalds wrote:
> 
>  - confusion about user/kernel mode, where "do_signal()" will return 
>    without doing anything at all if we're in user mode.

	s/in/not returning to/

Duh.

		Linus
