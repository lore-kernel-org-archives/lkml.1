Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbYIPGWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYIPGWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 02:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYIPGWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 02:22:32 -0400
Received: from 1wt.eu ([62.212.114.60]:4066 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbYIPGWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 02:22:31 -0400
Date: Tue, 16 Sep 2008 08:22:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: karthikeyan S <karthispeaks@gmail.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: A bug (probably) in stop_all_threads
Message-ID: <20080916062226.GA29225@1wt.eu>
References: <3bedf6ab0809130127j7ed9d372pcb15e1b001178600@mail.gmail.com> <o44nc4dd8tpl94vf9bv81oklq8lt29112t@4ax.com> <20080916051751.GA28475@1wt.eu> <3bedf6ab0809152249r524cce0v1c14bfdff46aa12d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bedf6ab0809152249r524cce0v1c14bfdff46aa12d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 11:19:58AM +0530, karthikeyan S wrote:
> Hi Willy,
> 
> Thanks for getting back. Yes, I tried to set the state to
> TASK_INTERRUPTIBLE. It solves the issue. The other processes now get a
> chance to handle the SIGSTOP sent to them.

OK, that will help me review the current code and compare it with 2.6.
If you could send me your patch, it will even save me more time. Based
on your report, it's very likely that it will get merged.

Thanks,
Willy

