Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZKDAVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZKDAVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZKDAVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:21:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbZKDAVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:21:15 -0500
Date: Tue, 3 Nov 2009 16:17:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Arve Hj?nnev?g <arve@android.com>, Brian Swetland <swetland@google.com>
Subject: Re: drivers/video/msm: update to new kernel
Message-Id: <20091103161733.970b885f.akpm@linux-foundation.org>
In-Reply-To: <20091022085639.GA30548@elf.ucw.cz>
References: <20091022085639.GA30548@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 10:56:39 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> TASK_INTERRUPTIBLE and friends are now only available after including
> <linux/sched.h>, so include it when needed.
> 
> bus_id is no longer available/neccessary, so remove that.
> 
> Android pmem driver is not available in mainline, so remove its hooks
> from drivers/video.
> 

What is the impact of these changes?

#2 looks like it's a build fix.  #3 looks like it isn't a build fix. 
#1 is a mystery.

