Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYEWOUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYEWOUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYEWOUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:20:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50789 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751980AbYEWOUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:20:25 -0400
Date: Fri, 23 May 2008 09:20:25 -0500
From: Paul Jackson <pj@sgi.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH] cpusets: fix bug of adding inexistent cpu or mem
Message-Id: <20080523092025.0e3a7eff.pj@sgi.com>
In-Reply-To: <483676AD.9020303@cn.fujitsu.com>
References: <483676AD.9020303@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai wrote:
> Adding inexistent cpu to a cpuset will be omitted quietly.
> It should return -EINVAL.

I like this PATCH - thank-you.  It was definitely a bug that
trying to add a nonexistent CPU to a cpuset emptied that cpuset
of its current CPUs, returning "success", not an "error".

Acked-by: Paul Jackson <pj@sgi.com>

(By the way, the word "inexistent" is not so commonly used
as is the word "nonexistent", but both words are legitimate,
and mean the same thing.)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
