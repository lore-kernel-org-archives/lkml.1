Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYE3KH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYE3KH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYE3KHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:07:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42903 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751545AbYE3KHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:07:21 -0400
Date: Fri, 30 May 2008 10:53:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: miaox@cn.fujitsu.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH 2/3] cpusets: restructure the function update_cpumask()
 and update_nodemask()
Message-ID: <20080530105302.0f447003@core>
In-Reply-To: <483FAE13.5080101@cn.fujitsu.com>
References: <483FAE13.5080101@cn.fujitsu.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -766,6 +766,38 @@ static void cpuset_change_cpumask(struct task_struct *tsk,
>  }
>  
>  /*

Trivial only: The kernel-doc bits should be /**, 3 of them. The fourth
function doesn't have kernel-doc headers/format so is fine as is (or
could grow them - hint ;))

Alan

