Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZCCUli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZCCUli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZCCUla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:41:30 -0500
Received: from quackingmoose.com ([63.73.180.143]:33451 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753787AbZCCUl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:41:29 -0500
Date: Tue, 3 Mar 2009 12:41:26 -0800
From: Aaron Straus <aaron@merfinllc.com>
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: kernel BUG at kernel/workqueue.c:291
Message-ID: <20090303204125.GB28232@merfinllc.com>
References: <49A84376.6030800@aei.mpg.de> <49ABBA44.1060302@aei.mpg.de> <20090302232643.7c7ca284.akpm@linux-foundation.org> <1236093413.9631.58.camel@heimdal.trondhjem.org> <49AD4B55.5060504@aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD4B55.5060504@aei.mpg.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carsten,

On Mar 03 04:23 PM, Carsten Aulbert wrote:
> > struct rpc_task does admittedly share storage for the work queue and the
> > rpc wait queue links, but if that were to be causing the reported
> > corruption, then it would mean that an rpc_task is simultaneously on a
> > wait queue and trying to execute on a work queue. I have no history of
> > that ever having happened.
> 
> Anything I might be able to give to you helping you to narrow it down
> somewhat? As written I suspect a certain type of user jobs, but since
> literally 1000s of these ran over the course of several days it might be
> hard to trigger this reliably again.

Out of curiosity, do you know (approximately) the last kernel you ran
which did not show the BUG?

i.e. we know 2.6.27.14 is bad, what was the last known good kernel?

Thanks!

				=a=


-- 
===================
Aaron Straus
aaron@merfinllc.com
