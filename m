Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYG1FQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYG1FQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 01:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYG1FQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 01:16:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41325 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752003AbYG1FQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 01:16:42 -0400
Date: Mon, 28 Jul 2008 00:16:40 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpuset: speed up sched domain partition
Message-Id: <20080728001640.041f61b7.pj@sgi.com>
In-Reply-To: <488D332D.3000501@cn.fujitsu.com>
References: <488D332D.3000501@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai wrote:
> All child cpusets contain a subset of the parent's cpus, so we can skip
> them when partitioning sched domains.

Nice - thanks.

Reviewed-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
