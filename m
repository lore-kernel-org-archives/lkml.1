Return-Path: <linux-kernel-owner+w=401wt.eu-S1751338AbXCOTGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbXCOTGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXCOTGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:06:30 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbXCOTG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:06:29 -0400
Date: Thu, 15 Mar 2007 11:06:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Aloni <da-x@monatomic.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: thread stacks and strict vm overcommit accounting
Message-Id: <20070315110621.9a9defaf.akpm@linux-foundation.org>
In-Reply-To: <20070313163320.GA28104@localdomain>
References: <20070313163320.GA28104@localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Mar 2007 18:33:20 +0200 Dan Aloni <da-x@monatomic.org> wrote:
> Hello,
> 
> This question is relevent to 2.6.20.
> 
> I noticed that if the RSS for the stack size is say, 8MB, running
> a single-threaded process doesn't incur an increase of 8MB to
> Committed_AS (/proc/meminfo).
> 
> However, on multi-threaded apps linked with pthread (on Debian
> Etch with 2.6.20 vanilla x86_64), every thread will incur the
> the specified maximum stack size RSS (assuming that you use
> the default attr). In other words, it appears that vm accounting
> works differently in that case.
> 
> Is this the intended behaviour?

That sounds like a bug to me.
