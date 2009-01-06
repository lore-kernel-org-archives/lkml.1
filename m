Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbZAFKJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbZAFKJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZAFKI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:08:58 -0500
Received: from ozlabs.org ([203.10.76.45]:50075 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZAFKI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:08:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] sched: fix double kfree
Date: Tue, 6 Jan 2009 20:38:51 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
References: <496326BA.60605@cn.fujitsu.com>
In-Reply-To: <496326BA.60605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901062038.52598.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009 20:09:06 Li Zefan wrote:
> Impact: fix double kfree in failure path
> 
> It's not the responsibility of init_rootdomain() to free root_domain
> allocated by alloc_rootdomain().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks, you're right.

Good catch!
Rusty.
