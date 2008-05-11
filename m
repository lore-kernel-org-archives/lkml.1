Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYEKOOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYEKOOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYEKOOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:14:06 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47603 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753748AbYEKOOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:14:05 -0400
Date: Sun, 11 May 2008 09:14:03 -0500
From: Paul Jackson <pj@sgi.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm, travis@sgi.com
Subject: Re: [PATCH] Make for_each_cpu_mask a bit smaller
Message-Id: <20080511091403.a75f5b78.pj@sgi.com>
In-Reply-To: <20080511135039.GA3286@mailshack.com>
References: <20080511135039.GA3286@mailshack.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander wrote:
> This patch
> changes for_each_cpu_mask to use only one function: a newly
> introduced find_next_cpu.

I believe that it's for_each_cpu_mask which is newly introduced,
not find_next_cpu ... just a typo, granted.

Any chance that you could make the same change to nodemask.h?
Where practical, I like to keep cpumask.h and nodemask.h the same.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
