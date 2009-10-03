Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZJCLSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZJCLSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 07:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZJCLSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 07:18:41 -0400
Received: from lo.gmane.org ([80.91.229.12]:35622 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbZJCLSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 07:18:40 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: matthieu castet <castet.matthieu@free.fr>
Subject: Re: [PATCH] Added =?utf-8?b?UFJfU0VUX1BST0NUSVRMRV9BUkVB?= option for prctl()
Date: Sat, 3 Oct 2009 11:18:13 +0000 (UTC)
Message-ID: <loom.20091003T131407-865@post.gmane.org>
References: <1254518602.5050.4.camel@hurina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.57.151.96 (Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.0.14) Gecko/2009090216 Ubuntu/9.04 (jaunty) Firefox/3.0.14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timo Sirainen <tss <at> iki.fi> writes:

> 
> PR_SET_PROCTITLE_AREA updates mm_struct->arg_start and arg_end to the
> given pointers, which makes it possible for user space to implement
> setproctitle(3) cleanly.
> 
>
Why can't you use PR_SET_NAME ?

And with PR_SET_NAME, you can a name per thread, which you can't do by changing
arg[0] name (it should be shared across all thread).

Matthieu

