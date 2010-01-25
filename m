Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517Ab0AYVdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0AYVdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438Ab0AYVc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:32:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49022
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384Ab0AYVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:32:57 -0500
Date: Mon, 25 Jan 2010 13:33:08 -0800 (PST)
Message-Id: <20100125.133308.117730889.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, netdev@vger.kernel.org, x86@kernel.org,
       mingo@redhat.com, fweisbec@gmail.com, dan.j.williams@intel.com,
       borislav.petkov@amd.com, ying.huang@intel.com, lenb@kernel.org,
       neilb@suse.de, cl@linux-foundation.org, eric.dumazet@gmail.com,
       arnd@arndb.de
Subject: Re: [PATCH 4/8] percpu: add __percpu sparse annotations to net
 drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1264432935-10453-5-git-send-email-tj@kernel.org>
References: <1264432935-10453-1-git-send-email-tj@kernel.org>
	<1264432935-10453-5-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Tue, 26 Jan 2010 00:22:11 +0900

> Add __percpu sparse annotations to net drivers.
> 
> These annotations are to make sparse consider percpu variables to be
> in a different address space and warn if accessed without going
> through percpu accessors.  This patch doesn't affect normal builds.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
