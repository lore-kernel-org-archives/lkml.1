Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbXIZRez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbXIZRez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXIZRes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:34:48 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:59805 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbXIZRer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:34:47 -0400
Date: Wed, 26 Sep 2007 19:32:33 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: balbir@linux.vnet.ibm.com
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Jonathan Lim <jlim@sgi.com>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] taskstats: separate PID/TGID stats producers to
 complete the TGID ones
Message-ID: <20070926193233.50f7a26a@localhost.localdomain>
In-Reply-To: <46F559A5.5060900@linux.vnet.ibm.com>
References: <20070921233038.21607.51089.stgit@localhost.localdomain>
	<46F559A5.5060900@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sat, 22 Sep 2007 23:36:29 +0530,
Balbir Singh <balbir@linux.vnet.ibm.com> a écrit :

[reordered]

> How about calling this one fill_threadgroup_stats()?
> How about we call function add_tsk_stats()?
> I still prefer braces around do <--> while, I think the code is easier
> to read with them.
> Could we further split the tsacct and delayacct/taskstats patches.

Hi Balbir,

Thank for your review, hopefully I addressed all your items in this
series.

> So we always call fill_threadgroup later, is there a reason for
> that. Can the order of calls be arbitrary or is there a dependency?

Yes, as you saw there is this dependency, it is needed only for
[PATCH 7/8] taskstats: fix stats->ac_exitcode to work on threads and use group_exit_code
but I found it simpler to put the calls in the right order from the
beginning.

Thanks again, and sorry for the double mail bomb.

-- 
Guillaume
