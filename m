Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbYDJUtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbYDJUtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbYDJUte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:49:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708AbYDJUte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:49:34 -0400
Date: Thu, 10 Apr 2008 13:49:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lzo: fix possible typo in decompresor
In-Reply-To: <1207859903.22001.36.camel@brick>
Message-ID: <alpine.LFD.1.00.0804101346240.3143@woody.linux-foundation.org>
References: <1207859903.22001.36.camel@brick>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Apr 2008, Harvey Harrison wrote:
>
> Shift of a le value seems strange, probably meant to shift the cpu-order
> variable as in the prvious section of the switch statement.

Hmm. This patch looks ObviouslyCorrect(tm), but it worries me that 
apparently the old broken code has been around since last July, and afaik 
it can never have worked on big-endian machines.

So did nobody ever use it, or why hasn't this ever triggered? How did you 
find this? A sparse warning?

		Linus
