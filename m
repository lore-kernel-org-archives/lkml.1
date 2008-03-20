Return-Path: <linux-kernel-owner+w=401wt.eu-S966728AbYCTAiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966728AbYCTAiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944128AbYCTASp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:18:45 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:53760 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940198AbYCTASm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RCnDFGMBGCNHoBo2hNAM2Bcj/hqt5zXuIlq5ezI3THrwDDTlAYUMTPuxmMxJ8Q3wWAcaJ/MFzqjNed0U8ZSDHFWddgq8DopISdfE5UiQW1EBFN84np0PFwYQP624i0x68e6xLoqW67aoYjR1ttjTXb/z0qZZGU54ZLakKLB0hvw=
Message-ID: <a8e1da0803191718o7f751306vf4d229d5e8fc133b@mail.gmail.com>
Date: Thu, 20 Mar 2008 08:18:38 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [mmotm build error] Re: [PATCH] [3/3] Use WARN_ON_SECS in rcupreempt.h
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com
In-Reply-To: <20080319115716.e255e49e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080310063922.GC6745@darkstar.te-china.tietoenator.com>
	 <20080319115716.e255e49e.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 2:57 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> HZ notdef; NO_HZ=y, HZ=250
>   CC      init/main.o
>  In file included from mmotm-2008-0318-1720/include/linux/rcupdate.h:59,
>                  from mmotm-2008-0318-1720/include/linux/rculist.h:10,
>                  from mmotm-2008-0318-1720/include/linux/dcache.h:8,
>                  from mmotm-2008-0318-1720/include/linux/fs.h:278,
>                  from mmotm-2008-0318-1720/include/linux/proc_fs.h:5,
>                  from mmotm-2008-0318-1720/init/main.c:14:
>  mmotm-2008-0318-1720/include/linux/rcupreempt.h: In function 'rcu_enter_nohz':
>   CC      init/do_mounts.o
>  mmotm-2008-0318-1720/include/linux/rcupreempt.h:92: error: 'HZ' undeclared (first use in this function)
>  mmotm-2008-0318-1720/include/linux/rcupreempt.h:92: error: (Each undeclared identifier is reported only once
>  mmotm-2008-0318-1720/include/linux/rcupreempt.h:92: error: for each function it appears in.)
>  mmotm-2008-0318-1720/include/linux/rcupreempt.h: In function 'rcu_exit_nohz':
>  mmotm-2008-0318-1720/include/linux/rcupreempt.h:99: error: 'HZ' undeclared (first use in this function)
>  make[2]: *** [init/main.o] Error 1

Hi,
There's a fix from andrew, please see:
http://lkml.org/lkml/2008/3/12/44

Regards
dave
