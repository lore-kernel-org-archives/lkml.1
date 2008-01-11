Return-Path: <linux-kernel-owner+w=401wt.eu-S1761828AbYAKR0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761828AbYAKR0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759759AbYAKR02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:26:28 -0500
Received: from brick.kernel.dk ([87.55.233.238]:25948 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbYAKR01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:26:27 -0500
Date: Fri, 11 Jan 2008 18:26:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Dillow <dillowda@ornl.gov>, Guillaume Chazarain <guichaz@yahoo.fr>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [patch] block: fix blktrace timestamps
Message-ID: <20080111172622.GA6258@kernel.dk>
References: <20080110234438.4826f658@inria.fr> <1200020661.5099.3.camel@obelisk.thedillows.org> <20080111090723.GI6258@kernel.dk> <20080111092334.GA8143@elte.hu> <20080111092513.GO6258@kernel.dk> <20080111094205.GE8143@elte.hu> <20080111095654.GR6258@kernel.dk> <20080111102953.GA27223@elte.hu> <1200065783.7480.2.camel@lap75545.ornl.gov> <20080111164430.GA18862@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111164430.GA18862@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11 2008, Ingo Molnar wrote:
> 
> * David Dillow <dillowda@ornl.gov> wrote:
> 
> > On Fri, 2008-01-11 at 11:29 +0100, Ingo Molnar wrote:
> > > (David, could you try the patch further below - does it fix bkltrace 
> > > timestamps too?)
> > 
> > Jens already got back to you, but I can confirm it works here as well.
> 
> great, thanks for testing it. (i'm not sure Jens saw the same issues as 
> you, so your test was useful too.)

Right, I merely checked that ktime_get() worked for me.

-- 
Jens Axboe

