Return-Path: <linux-kernel-owner+w=401wt.eu-S932144AbZHNCDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbZHNCDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbZHNCDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:03:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:40160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109AbZHNCDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:03:07 -0400
Message-ID: <4A84C58B.6050707@kernel.org>
Date: Fri, 14 Aug 2009 11:01:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [Patch] percpu: use the right flag for get_vm_area()
References: <20090813060235.5516.12662.sendpatchset@localhost.localdomain>
In-Reply-To: <20090813060235.5516.12662.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 14 Aug 2009 02:02:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> get_vm_area() only accepts VM_* flags, not GFP_*.
> 
> And according to the doc of get_vm_area(), here should be
> VM_ALLOC.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@elte.hu>

Ah... indeed.

Acked-by: Tejun Heo <tj@kernel.org>

Will forward to Linus with other two patches today.

Thanks.

-- 
tejun
