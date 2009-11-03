Return-Path: <linux-kernel-owner+w=401wt.eu-S1751150AbZKCOZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbZKCOZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZKCOZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:25:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZKCOZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:25:31 -0500
Date: Tue, 3 Nov 2009 16:25:33 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] Handle asynchronous page fault in a PV guest.
Message-ID: <20091103142533.GN27911@redhat.com>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com>
 <1257076590-29559-4-git-send-email-gleb@redhat.com>
 <20091103141423.GC10084@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103141423.GC10084@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 12:14:23PM -0200, Marcelo Tosatti wrote:
> On Sun, Nov 01, 2009 at 01:56:22PM +0200, Gleb Natapov wrote:
> > Asynchronous page fault notifies vcpu that page it is trying to access
> > is swapped out by a host. In response guest puts a task that caused the
> > fault to sleep until page is swapped in again. When missing page is
> > brought back into the memory guest is notified and task resumes execution.
> 
> Can't you apply this to non-paravirt guests, and continue to deliver
> interrupts while waiting for the swapin? 
> 
> It should allow the guest to schedule a different task.
But how can I make the guest to not run the task that caused the fault?

--
			Gleb.
