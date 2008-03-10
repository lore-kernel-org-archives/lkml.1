Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYCJTuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYCJTuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYCJTtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:49:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515AbYCJTtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:49:50 -0400
Date: Mon, 10 Mar 2008 12:48:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ptrace orig_ax on ia32 task
In-Reply-To: <47D589B9.1080109@redhat.com>
Message-ID: <alpine.LFD.1.00.0803101247250.5896@woody.linux-foundation.org>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080307225602.6491B26F990@magilla.localdomain> <47D589B9.1080109@redhat.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Mar 2008, Chuck Ebbert wrote:
> 
> That original patch is still unmerged as of -rc5.

The original is, but the modified one that just does this unconditionally 
for x86-64 isn't. See commit 84c6f6046c5a2189160a8f0dca8b90427bf690ea.

			Linus
