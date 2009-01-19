Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZASCpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZASCpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbZASCpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:45:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:56032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085AbZASCpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:45:20 -0500
Message-ID: <4973E938.4010408@kernel.org>
Date: Mon, 19 Jan 2009 11:45:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET x86:core/percpu] percpu: move PDA fields to percpu
References: <1232296759-2253-1-git-send-email-tj@kernel.org> <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
In-Reply-To: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Jan 2009 02:45:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo, Brian.

Brian Gerst wrote:
> 
> Here are the remaining patches rebased on top of these.

Ingo, here's git tree for kill-pda patches.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

I dropped early irq_stack_ptr relocation from 0004.  I'll post updated
patch as reply to the original patch.  If you think it's still
necessary, please feel free to discuss it.  I also added a patch to
kill PERCPU_VADDR_PREALLOC().  Will post the patch as a reply to 0005.

Thanks.

-- 
tejun
