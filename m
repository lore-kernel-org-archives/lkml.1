Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZBBGrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZBBGrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 01:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZBBGrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 01:47:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46213 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZBBGrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 01:47:32 -0500
Date: Mon, 2 Feb 2009 07:45:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kaz Kylheku <kkylheku@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: main thread pthread_exit/sys_exit bug!
Message-ID: <20090202064509.GA20237@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com> <20090201174159.4a52e15c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090201174159.4a52e15c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kaz Kylheku wrote:
>
> Basically, if you call pthread_exit from the main thread of a process, and keep
> other threads running, the behavior is ugly.

Yes, known problem.

Please look at

        [RFC,PATCH 3/3] do_wait: fix waiting for stopped group with dead leader
        http://marc.info/?t=119713920000003

I'll try to re-do and re-send this patch this week.

Oleg.

