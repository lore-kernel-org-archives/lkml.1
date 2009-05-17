Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZEQMjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZEQMjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZEQMja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:39:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:56555 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZEQMj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:39:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,207,1241420400"; 
   d="scan'208";a="143730222"
Date: Sun, 17 May 2009 20:39:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
Message-ID: <20090517123914.GA4221@localhost>
References: <20090517011906.GA6375@localhost> <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com> <20090517020829.GB6809@localhost> <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com> <20090517045800.GA32723@localhost> <93655eb70905162318oeccafa9p76b5594f9625aefc@mail.gmail.com> <20090517093004.GA2635@localhost> <93655eb70905170501q3caf04acj761ff61b539b7d40@mail.gmail.com> <20090517121711.GA3583@localhost> <93655eb70905170527t490653dge6e25a9e3724a918@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93655eb70905170527t490653dge6e25a9e3724a918@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 08:27:39PM +0800, Satish Eerpini wrote:
> > The clear command can be a big clue. Can you try these commands in the
> > terminal and show us the two log files?
> >
> >        strace -o all.log -T clear
> >        strace -o sum.log -c clear
> >
> ok here go the logs :
> 

It looks that the "clear" command runs pretty fast in itself.
To be sure, can you run this?

strace -o log -tt clear

Or maybe the time is spent in gnome-terminal or bash?
What if you change them to xterm and dash?

> "sum.log"
> 
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  93.27    0.000485         485         1           execve
>   6.73    0.000035           7         5           ioctl
>   0.00    0.000000           0         3           read
>   0.00    0.000000           0         1           write
>   0.00    0.000000           0         4           open
>   0.00    0.000000           0         4           close
>   0.00    0.000000           0         3         2 access
>   0.00    0.000000           0         3           brk
>   0.00    0.000000           0         1           munmap
>   0.00    0.000000           0         2           mprotect
>   0.00    0.000000           0         9           mmap2
>   0.00    0.000000           0         3         1 stat64
>   0.00    0.000000           0         4           fstat64
>   0.00    0.000000           0         1           set_thread_area
> ------ ----------- ----------- --------- --------- ----------------
> 100.00    0.000520                    44         3 total
> 
> I have also attached the logs, in case that is more useful .
> 
> Cheers
> Satish
> 
> 
> 
> -- 
> http://satish.playdrupal.com



