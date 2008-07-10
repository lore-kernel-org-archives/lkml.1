Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbYGJQlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbYGJQlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbYGJQlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:41:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31555 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYGJQlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:41:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=HaQd2lJXMd7/BtEP2J6WGRl+W3uNEzSo+Yb482KrHVXpm8Pq4a+lz3vhpsAypQfNi
	WTzVFV/gImvTxyh+9YSww==
Message-ID: <6599ad830807100941k330bb62cg7ae6a3d611e2dffa@mail.gmail.com>
Date: Thu, 10 Jul 2008 09:41:06 -0700
From: "Paul Menage" <menage@google.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Libcg Devel Mailing List" <libcg-devel@lists.sourceforge.net>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Peter Zijlstra" <pzijlstr@redhat.com>, kamezawa.hiroyu@jp.fujitsu.com,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080710140624.GB3782@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701191126.GA17376@redhat.com>
	 <6599ad830807100207q26cf2416qb8d38d1d715b5ba0@mail.gmail.com>
	 <20080710140624.GB3782@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 7:06 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> This looks interesting. So above method should solve atleast the
> reliability issue of event transport to user space. Got few thougts.
>
> - Hopefully number of hiearchies will not explode as we will be
>  mounting one hierarchies per event type (uid change, gid change,
>  exec, maybe fork etc.).

In what circumstances would you want to reclassify processes to a
different cgroup on a fork?

Paul
