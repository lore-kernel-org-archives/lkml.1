Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbXF3H6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbXF3H6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 03:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXF3H54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 03:57:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbXF3H5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 03:57:55 -0400
Date: Sat, 30 Jun 2007 00:57:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan <metalifloyd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: PROBLEM: SATA AHCI driver significant throughput loss in
 2.6.22-rc5-g75154f40-dirty
Message-Id: <20070630005747.9bc9ba40.akpm@linux-foundation.org>
In-Reply-To: <439fa30706262117u2d5553dfp8395c6ca41574a8c@mail.gmail.com>
References: <439fa30706262117u2d5553dfp8395c6ca41574a8c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 00:17:24 -0400 Dan <metalifloyd@gmail.com> wrote:

> Something changed with the AHCI SATA driver in the latest git version.
> With 2.6.21 I get ~49MB/sec according to hdparm. Using the latest git
> version I only get ~8MB/sec. I've attached my .config and have
> included some info about my system below. Please let me know if you
> need more information or if I can help test anything.
> 
> Lenovo Thinkpad T60p

Until we know how widespread this damage is, we'd need to consider this
a blocking bug.

Are you able (as a matter of some urgency) to run a git bisection 
search to identify the offending commit?

Thanks.
