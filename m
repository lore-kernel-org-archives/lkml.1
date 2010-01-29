Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563Ab0A2VQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0A2VQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463Ab0A2VQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:16:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab0A2VQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:16:18 -0500
Date: Fri, 29 Jan 2010 13:14:10 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/10] usb: gadgetfs: Convert semaphore to mutex
Message-ID: <20100129211410.GB7265@suse.de>
References: <20100129203549.526478432@linutronix.de>
 <20100129203613.628793121@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129203613.628793121@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 08:38:59PM -0000, Thomas Gleixner wrote:
> The semaphore data->lock is semantically a mutex. Convert it to a real
> mutex.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
