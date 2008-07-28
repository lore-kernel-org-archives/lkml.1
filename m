Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYG1GBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYG1GBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 02:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYG1GBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 02:01:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51785 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753041AbYG1GBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 02:01:43 -0400
Date: Mon, 28 Jul 2008 01:01:41 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
Message-Id: <20080728010141.fbd33866.pj@sgi.com>
In-Reply-To: <488D332A.1030008@cn.fujitsu.com>
References: <488D332A.1030008@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> -	q = kfifo_alloc(number_of_cpusets * sizeof(cp), GFP_KERNEL, NULL);


The block comment for rebuild_sched_domains() states:

> ... May take callback_mutex during
> * call due to the kfifo_alloc() and kmalloc() calls.

I suspect that mention of kfifo_alloc() is no longer correct,
with your patch.  If so, perhaps you could send a little additional
fix patch, to remove that mention from the comment.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
