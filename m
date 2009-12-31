Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbZLaMZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbZLaMZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZLaMZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:25:15 -0500
Received: from mx.treblig.org ([80.68.94.177]:45688 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZLaMZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:25:15 -0500
Date: Thu, 31 Dec 2009 12:19:58 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: perf: confused by cc1
Message-ID: <20091231121957.GA3957@gallifrey>
References: <20091231014714.GA8313@gallifrey> <4B3C1619.7060001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3C1619.7060001@cn.fujitsu.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.31.5-kvm-i386-2009-10-30 (i686)
X-Uptime: 12:16:37 up 45 days, 19:26,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Xiao Guangrong (xiaoguangrong@cn.fujitsu.com) wrote:
> 
> Dr. David Alan Gilbert wrote:
> > Hi,
> >   I'm running 2.6.33rc2 and thought I'd have a play with perf; its
> > symbol resolution code seems to be getting itself a bit confused however:

<snip>

> 
> Your kernel is relocatable? See: http://lkml.org/lkml/2009/12/29/358

Yes it is, however the values I get for the symbols in all 3 cases seems
to be the same:

dg@major:~$ readelf -s /lib/modules/2.6.33-rc2-major/build/vmlinux|grep " _text"|head -1
 49775: ffffffff81000000     0 NOTYPE  GLOBAL DEFAULT    1 _text
dg@major:~$ grep _text /lib/modules/2.6.33-rc2-major/build/System.map |head -1
ffffffff81000000 T _text
dg@major:~$ grep _text /proc/kallsyms |head -2
ffffffff81000000 T _text
ffffffff81023840 T set_kernel_text_ro

Do you think that it could still be the cause?

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
