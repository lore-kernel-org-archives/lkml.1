Return-Path: <linux-kernel-owner+w=401wt.eu-S935901AbZLQUJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935901AbZLQUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932475AbZLQUJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:09:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761739AbZLQUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:09:53 -0500
Date: Thu, 17 Dec 2009 12:09:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@linux-foundation.org, h-shimamoto@ct.jp.nec.com,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: revert "config FS_JOURNAL_INFO"
Message-Id: <20091217120920.7521d1f3.akpm@linux-foundation.org>
In-Reply-To: <b6fcc0a0912170031u162b7f56kf9f6adc23e24278c@mail.gmail.com>
References: <b6fcc0a0912170031u162b7f56kf9f6adc23e24278c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 10:31:52 +0200
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Can we please revert commit e4c570c4cb7a95dbfafa3d016d2739bf3fdfe319
> "task_struct: make journal_info conditional"
> 
> I think I gave a good enough arguments to not merge it.
> To iterate:
> * patch makes impossible to start using ext3 on EXT3_FS=n kernels
> without reboot.
> * this is done only for one pointer on task_struct
> 
> None of config options which define task_struct are tristate directly
> or effectively.
> 
> There are other examples where we don't do this:
> * quota stuff on superblock aren't ifdeffed because of modular XFS
> with quota support.
> * exports operations and  s_anon for NFS
> and so on

Confused.  I "dropped" that patch when you pointed out the problem then
forgot about it.

Maybe I dropped something else by accident.  argh.

I agree - I'll queue a revert.


