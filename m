Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbXA1UZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbXA1UZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 15:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932830AbXA1UZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 15:25:38 -0500
Received: from dvhart.com ([64.146.134.43]:44874 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932828AbXA1UZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 15:25:37 -0500
Message-ID: <45BD06AC.1080008@mbligh.org>
Date: Sun, 28 Jan 2007 12:25:16 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug report : reproducible memory allocator bug in 2.6.19.2
References: <20070128200917.GA16571@Krystal>
In-Reply-To: <20070128200917.GA16571@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Hi,
> 
> Trying to build cross-compilers (or kernels) on a 2-way x86_64 (amd64) with
> make -j3 triggers the following OOPS after about 30 minutes on
> 2.6.19.2. Due to the amount of time and the heavy load it takes before it
> happens, I suspect a race condition. Memtest86 tests passed ok. The
> amount of swap used when the condition happens is about 52k and stable
> (only ~800MB/1GB are used).
> 
> I am going to give it a look, but I suspect you might help narrowing it
> down more quickly. Any insight would be appreciated.

Mmm. that's going to be messy to debug ... but didn't we already know
that kernel was racy? Or is 2.6.19.2 after that fix already? Does 20-rc6
still break?

M.
