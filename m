Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbXGGAcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbXGGAcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 20:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbXGGAcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 20:32:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbXGGAcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 20:32:35 -0400
Date: Fri, 6 Jul 2007 17:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] Text Edit Lock - Alternative i386
Message-Id: <20070706173222.fb16b739.akpm@linux-foundation.org>
In-Reply-To: <20070703164030.836768613@polymtl.ca>
References: <20070703163818.785635235@polymtl.ca>
	<20070703164030.836768613@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2007 12:38:21 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> alternative.c can use the text edit lock to remove CPU HOTPLUG special cases.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  arch/i386/kernel/alternative.c |    5 +++++

x86_64 uses this file as well, so the patchset breaks the x86-64 build.

Look, x86 is just a minefield.  please compile-test your changes much
better than you have been doing.  That means *at least* allnoconfig,
allyesconfig and allmodconfig on i386 and x86_64.

Thanks.
