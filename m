Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZFEFiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZFEFiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZFEFiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:38:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbZFEFiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:38:13 -0400
Date: Thu, 4 Jun 2009 22:38:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
 2.6.30-rc8.
Message-Id: <20090604223805.2962e826.akpm@linux-foundation.org>
In-Reply-To: <4A289928.7040508@oracle.com>
References: <4A289928.7040508@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jun 2009 12:03:52 +0800 Tao Ma <tao.ma@oracle.com> wrote:

> Hi list,
>        In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable large 
> to be 281474974617600.
> While in a x86 box, it is 931131392 which looks sane.
> 
> [root@test8 ~]# ll /proc/kcore
> -r-------- 1 root root 281474974617600 Jun  5 11:15 /proc/kcore
> 
> [root@ocfs2-test9 ~]$ ll /proc/kcore
> -r-------- 1 root root 931131392 Jun  5 11:58 /proc/kcore
> 
> I just noticed this when kexec fails in "Can't find kernel text map area 
> from kcore".
> 
> Is there something wrong?
> 

fs/proc/kcore.c hasn't changed since October last year.  Was 2.6.29 OK?
Earlier kernels?

Thanks.
