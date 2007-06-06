Return-Path: <linux-kernel-owner+w=401wt.eu-S965938AbXFFXHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965938AbXFFXHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965566AbXFFXHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:07:14 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:57597 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965494AbXFFXHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:07:12 -0400
Date: Thu, 7 Jun 2007 08:05:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Ingo Molnar <mingo@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Big problems applying patch-2.6.21.3-rt9
Message-ID: <20070606230558.GA11525@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Bird <tim.bird@am.sony.com>, Ingo Molnar <mingo@redhat.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <46673964.1000004@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46673964.1000004@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 03:47:00PM -0700, Tim Bird wrote:
> Ingo,
> 
> I saw lots of problems trying to apply the latest rt-preempt patch.
> Maybe some bits got included by mistake in the patch?
> 
> Here's what I saw:
> $ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.3.tar.bz2
> $ wget http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.3-rt9
> $ tar -xjf linux-2.6.21.3.tar.bz2
> $ cd linux-2.6.21.3
> $ patch -p1 -f <../patch-2.6.21.3-rt9
> ... lots of errors, (many "already applied" errors if you don't use '-f')...

Use 2.6.21 proper. -rt9 includes the 2.6.21.3 changes, hence the
application failure. This was brought up a few days ago.
