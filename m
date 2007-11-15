Return-Path: <linux-kernel-owner+w=401wt.eu-S1765895AbXKOUH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765895AbXKOUH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbXKOUHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:07:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58577 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbXKOUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:07:48 -0500
Date: Thu, 15 Nov 2007 12:07:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Micah Dowty <micah@vmware.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>
Subject: Re: High priority tasks break SMP balancer?
In-Reply-To: <20071115191408.GA4914@vmware.com>
Message-ID: <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net>
 <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com>
 <20071115191408.GA4914@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Micah Dowty wrote:

> For reference, the exact test I used with git-bisect is attached. The
> C program (priosched) starts two busy-looping threads and a
> high-priority high-frequency thread which uses relatively little
> CPU. The Python program repeatedly starts the C program, runs it for a
> half second, and measures the resulting imbalance in CPU usage. On
> kernels prior to the above commit, this reports values within about
> 10% of 1.0. On later kernels, it crashes within a couple iterations
> due to a divide-by-zero error :)

The kernel crashes? Sounds like your application crashes with a divide by 
zero?


