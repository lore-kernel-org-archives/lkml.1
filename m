Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370Ab0A2VQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0A2VQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420Ab0A2VQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:16:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:36353 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab0A2VQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:16:14 -0500
Date: Fri, 29 Jan 2010 13:13:58 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 08/10] drivers/base: Convert dev->sem to mutex
Message-ID: <20100129211358.GA7265@suse.de>
References: <20100129203549.526478432@linutronix.de>
 <20100129203613.665951035@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129203613.665951035@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 08:39:02PM -0000, Thomas Gleixner wrote:
> The semaphore is semantically a mutex. Convert it to a real mutex and
> clean up all users outside of drivers/base as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

