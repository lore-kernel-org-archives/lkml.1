Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbZCCPXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbZCCPXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbZCCPXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:23:19 -0500
Received: from welcomes-you.com ([85.214.50.128]:57509 "EHLO
	smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbZCCPXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:23:18 -0500
Message-ID: <49AD4B55.5060504@aei.mpg.de>
Date: Tue, 03 Mar 2009 16:23:01 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: kernel BUG at kernel/workqueue.c:291
References: <49A84376.6030800@aei.mpg.de> <49ABBA44.1060302@aei.mpg.de>	 <20090302232643.7c7ca284.akpm@linux-foundation.org> <1236093413.9631.58.camel@heimdal.trondhjem.org>
In-Reply-To: <1236093413.9631.58.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

Trond Myklebust schrieb:
> struct rpc_task does admittedly share storage for the work queue and the
> rpc wait queue links, but if that were to be causing the reported
> corruption, then it would mean that an rpc_task is simultaneously on a
> wait queue and trying to execute on a work queue. I have no history of
> that ever having happened.

Anything I might be able to give to you helping you to narrow it down
somewhat? As written I suspect a certain type of user jobs, but since
literally 1000s of these ran over the course of several days it might be
hard to trigger this reliably again.

Cheers

Carsten
