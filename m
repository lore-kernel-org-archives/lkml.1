Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZKHMEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZKHMEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZKHMEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:04:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:40700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZKHME3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:04:29 -0500
Message-ID: <4AF6B3C6.8080407@kernel.org>
Date: Sun, 08 Nov 2009 21:04:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Alan Cox <alan@linux.intel.com>, mel@csn.ul.fi,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] slqb: A not quite so trivial warning
References: <20091106112942.14595.29799.stgit@localhost.localdomain> <4AF6ADE1.60201@cs.helsinki.fi>
In-Reply-To: <4AF6ADE1.60201@cs.helsinki.fi>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Pekka Enberg wrote:
> Alan Cox wrote:
>> mm/slqb.c:2773: warning: initialization from incompatible pointer type
>>
>> Variable scope...
>>
>> Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> I don't see this warning in my tree. Is this coming from linux-next? Did
> someone change DEFINE_PER_CPU not to prefix the variable name with
> "per_cpu__"?

Yeap, the prefix is dropped in the latest percpu tree.  Patch already
pending.

  http://patchwork.kernel.org/patch/56948/

Thanks.

-- 
tejun
