Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYHSTsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYHSTsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYHSTsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:48:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbYHSTsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:48:23 -0400
Date: Tue, 19 Aug 2008 12:47:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: post-factum <pfactum@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: BUG: scaling doesn't work after waking up
Message-Id: <20080819124752.cf195347.akpm@linux-foundation.org>
In-Reply-To: <20080809115200.6d2ee6dc@gmail.com>
References: <20080809115200.6d2ee6dc@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2008 11:52:00 +0300
post-factum <pfactum@gmail.com> wrote:

> After suspending to RAM scaling doesn't work for the second core of my
> Pentium Dual-Core T2330.
> 
> Before suspending:
> cpu MHz         : 800.000	#CPU0
> cpu MHz         : 800.000	#CPU1
> 
> After suspending and waking up:
> cpu MHz         : 800.000	#CPU0
> cpu MHz         : 1596.079	#CPU1
> 
> I've observed it with kernel 2.6.25 and current 2.6.26.
> 
> Processor ID:
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Pentium(R) Dual  CPU  T2330  @ 1.60GHz
> stepping        : 13
> 

(cc cpufreq@vger.kernel.org)
