Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYGPHO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYGPHO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYGPHOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:14:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYGPHOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:14:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=EfB0dbNRQ+SsqivxDLvLSAyWlda6HXnKugsIQCPgbr6bqkedlhu47JS/3IWXpYdmd
	ev4tMB7u2ItFyjXesND8Q==
Message-ID: <6599ad830807160014t2ae6cb4dm5c273d612bf4522b@mail.gmail.com>
Date: Wed, 16 Jul 2008 00:14:32 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] cpuset: Don't pass empty cpumasks to partition_sched_domains()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <487D6E49.7070805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <487D6E49.7070805@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 8:43 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> i create a lots of empty cpusets(empty cpumasks) and
> turn off the "sched_load_balance" in top cpuset.
>
> And i found that all these empty cpumasks are passed to
> partition_sched_domains() in rebuild_sched_domains(),
> it's very time-consuming for partition_sched_domains()
> and it's not need.
>
> It also reduce memory consumed and some works in
> rebuild_sched_domains() too.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Seems reasonable, and I don't think that it clashes with the other
outstanding rebuild_sched_domains() patches.

Paul
