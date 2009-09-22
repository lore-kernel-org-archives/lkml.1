Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382AbZIVTws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbZIVTws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZIVTws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:52:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZIVTwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:52:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] make refrigerator cold
Date: Tue, 22 Sep 2009 21:54:09 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20090921210416.1982bcab@nehalam>
In-Reply-To: <20090921210416.1982bcab@nehalam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909222154.09726.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Stephen Hemminger wrote:
> By marking it cold, then the code path in kernel thread 
> usage of try_to_freeze() that is normally used be
> selected.

The sentence above isn't very clear IMO, could you please rephrase?

> Don't think it matters that much for performance but the
> concordance of this patch struck me as humorous.

Well, yeah.

> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> 
> --- a/include/linux/freezer.h	2009-09-21 20:34:17.579233461 -0700
> +++ b/include/linux/freezer.h	2009-09-21 20:35:25.724322028 -0700
> @@ -47,7 +47,7 @@ static inline bool should_send_signal(st
>  /* Takes and releases task alloc lock using task_lock() */
>  extern int thaw_process(struct task_struct *p);
>  
> -extern void refrigerator(void);
> +extern void refrigerator(void) __cold;
>  extern int freeze_processes(void);
>  extern void thaw_processes(void);
