Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbXIJPfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbXIJPfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 11:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760128AbXIJPfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 11:35:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbXIJPfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 11:35:30 -0400
Message-ID: <46E5643D.50005@redhat.com>
Date: Mon, 10 Sep 2007 11:35:25 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Yishai Hadas <Yishai.Hadas@aladdin.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Health monitor of a multi-threaded process
References: <C4A438513D3F12459455E5D43FD54783017A2E06@extlv102.eAladdin.org>
In-Reply-To: <C4A438513D3F12459455E5D43FD54783017A2E06@extlv102.eAladdin.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yishai Hadas wrote:
> Hi List,
> 
> I'm looking for any mechanism in a multi-threaded process to monitor the
> health of its running threads - or by a specific monitor thread or by
> any other mechanism.
> 
> It includes the following aspects:
> 
>     1) Threads are running and not stuck on any lock. 

If you're using posix locking, you'll never find yourself busy-waiting for very 
long.  Use ps or top.

>     2) Threads are running and have not died accidentally. 

Use ps or top.

>     3) Threads are not consuming "too much" CPU/Memory. 

Use ps or top.  You'll have to decide how much is "too much".

>     4) Threads are not in any infinite loop. 

This requires solving the Halting Problem.  If your management is demanding this 
feature, I suggest informing them that it is mathematically impossible.

Just use top or ps.  Don't reinvent the wheel.  We've got a really good wheel. 
If you don't like top or ps as is, read the ps man page to see all the fancy 
formatting it can do, and parse it with a simple script in your favorite 
scripting language.

	-- Chris
