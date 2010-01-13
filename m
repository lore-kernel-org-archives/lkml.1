Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663Ab0AMUvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab0AMUvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273Ab0AMUvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:51:24 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17332 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab0AMUvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:51:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ruFvT+qgMmI4FvOpx1A8Y8ylTmWURD/118MkTqHUdw7foPM3e585VbwcbeiYs0Ygm
	MZSBfMf6GtV8RpWkA5/jQ==
Date: Wed, 13 Jan 2010 12:51:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch] hugetlb: Fix section mismatches #2
In-Reply-To: <4B4DE0C1.7080709@suse.com>
Message-ID: <alpine.DEB.2.00.1001131250510.24847@chino.kir.corp.google.com>
References: <20100113004855.550486769@suse.com> <20100113004938.715904356@suse.com> <alpine.DEB.2.00.1001130127450.469@chino.kir.corp.google.com> <4B4DE0C1.7080709@suse.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010, Jeff Mahoney wrote:

>  hugetlb_register_node calls hugetlb_sysfs_add_hstate, which is marked with
>  __init. Since hugetlb_register_node is only called by
>  hugetlb_register_all_nodes, which in turn is only called by hugetlb_init,
>  it's safe to mark both of them as __init.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Acked-by: David Rientjes <rientjes@google.com>
