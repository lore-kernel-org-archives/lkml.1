Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYEMCkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYEMCkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 22:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYEMCkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 22:40:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46077 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753384AbYEMCkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 22:40:23 -0400
Date: Mon, 12 May 2008 21:40:21 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, seto.hidetoshi@jp.fujitsu.com,
       menage@google.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: limit the input of
 cpuset.sched_relax_domain_level
Message-Id: <20080512214021.8ca3553e.pj@sgi.com>
In-Reply-To: <4828FC85.7020400@cn.fujitsu.com>
References: <4828FC85.7020400@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> We allow the inputs to be [-1 ... SD_LV_MAX), and return -EINVAL
> for inputs outside this range.

Good.  Thanks.

Signed-off-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
