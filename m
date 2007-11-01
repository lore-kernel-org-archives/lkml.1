Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXKANDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXKANDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbXKANDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:03:37 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50176 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756645AbXKANDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:03:37 -0400
Message-ID: <393922219.19211@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 1 Nov 2007 21:03:33 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
References: <E1ImlvH-0003YH-Qf@localhost> <20071030114250.GL25561@iucha.net> <E1ImpbK-0000l3-1u@localhost> <20071031000242.GP25561@iucha.net> <20071031035245.GQ25561@iucha.net> <E1In7S9-0001rv-NO@localhost> <20071031121606.GR25561@iucha.net> <20071031175318.GU25561@iucha.net> <E1InUH6-0001vE-1Y@localhost> <20071101122558.GX25561@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101122558.GX25561@iucha.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1InZht-0004lr-NN@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 07:25:58AM -0500, Florin Iucha wrote:
> On Thu, Nov 01, 2007 at 03:15:32PM +0800, Fengguang Wu wrote:
> > On Wed, Oct 31, 2007 at 12:53:18PM -0500, Florin Iucha wrote:
> > > This patch does not fix anything for me.  Even such light use of the
> > > reiserfs filesystem as pulling the linux-2.6 git tree updates caused
> > > one CPU to go to 75% iowait.
> >  
> > Thank you, Florin. Could you provide more details about sda7, such as
> > the mount option and output of `reiserfstune /dev/sda7`? I'll try to
> > reproduce it before asking for your help.
> 
> Fengguang,
> 
> root@zeus:~# mount | grep sda7
> /dev/sda7 on /scratch type reiserfs (rw,noatime)
> root@zeus:~# df -h /scratch/
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda7              38G   32G  5.7G  85% /scratch
[...]

Thank you. It seems the only difference with mine reiserfs is about
the 'noatime' - which I tried and saw no difference.

Or will the system or fs size/age make any difference? If you happen
to have a spare/swap partition, could you make a new reiserfs and
mount it and copy several less-than-4KB files into it and wait for 30s
and see what happen to pdflush?

btw, what's the exact kernel version you are running?

Thank you,
Fengguang

