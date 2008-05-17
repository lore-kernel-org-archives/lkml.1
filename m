Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYEQTU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYEQTU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYEQTUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:20:22 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44295 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbYEQTUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:20:22 -0400
Date: Sat, 17 May 2008 22:18:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, stsp@users.sourceforge.net
Subject: Re: pcspkr lockdep trace.
Message-ID: <20080517191827.GB8140@cs181133002.pp.htv.fi>
References: <20080517172612.GA3522@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080517172612.GA3522@codemonkey.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 01:26:12PM -0400, Dave Jones wrote:
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.26-0.13.rc2.git5.fc10.x86_64 #1
> -------------------------------------------------------
> ksoftirqd/0/4 is trying to acquire lock:
>  (&pcsp_chip.substream_lock){++..}, at: [<ffffffffa0265333>] pcsp_do_timer+0x5a/0x2b3 [snd_pcsp]
> 
> but task is already holding lock:
>  (&cpu_base->lock){++..}, at: [<ffffffff8104e0a8>] hrtimer_interrupt+0x79/0x14f
>...

Known bug:
  http://bugzilla.kernel.org/show_bug.cgi?id=10701

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

