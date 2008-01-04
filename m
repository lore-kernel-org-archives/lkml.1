Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYADHyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYADHyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 02:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYADHyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 02:54:25 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47014 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752248AbYADHyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 02:54:25 -0500
Date: Fri, 4 Jan 2008 01:54:21 -0600
From: Paul Jackson <pj@sgi.com>
To: Denis Cheng <crquan@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       emdow@us.ibm.com
Subject: Re: [PATCH] PROC_FS: get and set the smp affinity of tasks by
 read-write /proc/<pid>/smp_affinity
Message-Id: <20080104015421.cc7a89f7.pj@sgi.com>
In-Reply-To: <1199430221-28417-1-git-send-email-crquan@gmail.com>
References: <1199430221-28417-1-git-send-email-crquan@gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis wrote:
> +	length += sprintf(page + length, "\n");

Could that overrun the 'page' buffer by one byte?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
