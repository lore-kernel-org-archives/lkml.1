Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbXKOV3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbXKOV3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbXKOV24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:28:56 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38183 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759288AbXKOV24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:28:56 -0500
Date: Thu, 15 Nov 2007 13:28:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Micah Dowty <micah@vmware.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>
Subject: Re: High priority tasks break SMP balancer?
In-Reply-To: <20071115202425.GC4914@vmware.com>
Message-ID: <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net>
 <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com>
 <20071115191408.GA4914@vmware.com> <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com>
 <20071115202425.GC4914@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Micah Dowty wrote:

> Yes, the Python test harness crashes, not the kernel. It's just
> because on a kernel which exhibits this SMP balancer bug, within a
> couple of test iterations I'll hit a case where cpu1 was almost
> totally idle and the test harness divides by zero when calculating the
> imbalance.

I still have some problem understanding what you are complaining about? 
The patch that you bisected had some issues that were fixed later by 
Siddha.

