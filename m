Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbYEGOvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbYEGOvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYEGOve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:51:34 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59098 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbYEGOvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:51:33 -0400
Date: Wed, 7 May 2008 08:51:16 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: rae l <crquan@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: It's time to hack on dentry_stat?
Message-ID: <20080507145116.GV19219@parisc-linux.org>
References: <91b13c310805070726k7eb1384ex7d557b5dca4b567@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310805070726k7eb1384ex7d557b5dca4b567@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 10:26:58PM +0800, rae l wrote:
> I have noticed that struct dentry_stat_t dentry_stat is a struct with
> six fields,
> but only 2 of them are used, other 4 have never been used since v2.6.11,
> 
> from include/linux/dcache.h:
> 
> struct dentry_stat_t {
>         int nr_dentry;
>         int nr_unused;
>         int age_limit;          /* age in seconds */
>         int want_pages;         /* pages requested by system */
>         int dummy[2];
> };

You have to not break:

$ cat /proc/sys/fs/dentry-state 
122104  115846  45      0       0       0

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
