Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab0CLJqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:46:51 -0500
Received: from smtp-out.google.com ([216.239.44.51]:4651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab0CLJqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:46:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=P5NSDtFoAAEhFFo0erEMb3TVIxB3TtVmaF+/M0r8l+QziKYGFQZwrFVZwaGn9liFg
	wxb5/TDhjRymkS1i5Slxw==
Date: Fri, 12 Mar 2010 01:46:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH -mmotm 1/2] cpuset: fix the problem that cpuset_mem_spread_node()
 returns an offline node - fix
In-Reply-To: <4B99E62C.1020500@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003120145440.22682@chino.kir.corp.google.com>
References: <4B99E62C.1020500@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010, Miao Xie wrote:

> Remove unnecessary smp_wmb().
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

Andrew can easily fold this into its parent patch now before pushing to 
Linus, thanks!
