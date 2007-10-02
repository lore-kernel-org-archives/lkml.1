Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXJBXVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXJBXVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbXJBXVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:21:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53731 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbXJBXVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:21:34 -0400
Date: Tue, 2 Oct 2007 16:19:43 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anders Bostr?m <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: high load average when idle
Message-ID: <20071002161943.15411245@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.0.999.0710021514040.3579@woody.linux-foundation.org>
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
	<20071002150748.906970bc.akpm@linux-foundation.org>
	<alpine.LFD.0.999.0710021514040.3579@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 15:32:53 -0700 (PDT)

> And I wonder if the same kind thing is effectively happening here:
> the code is written so that it *tries* to sleep, but the rounding of
> the clock basically means that it's trying to sleep using a different
> clock than the one we're using to wake things up with, so some
> percentage of the time it doesn't sleep at all!

we're talking about a timer that (normally) is 5 seconds.

