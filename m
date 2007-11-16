Return-Path: <linux-kernel-owner+w=401wt.eu-S933979AbXKPCcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979AbXKPCcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757115AbXKPCbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:31:51 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48364 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757904AbXKPCbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:31:50 -0500
Date: Thu, 15 Nov 2007 18:31:49 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Micah Dowty <micah@vmware.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>
Subject: Re: High priority tasks break SMP balancer?
In-Reply-To: <20071115213510.GA16079@vmware.com>
Message-ID: <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net>
 <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com>
 <20071115191408.GA4914@vmware.com> <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com>
 <20071115202425.GC4914@vmware.com> <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com>
 <20071115213510.GA16079@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Micah Dowty wrote:

> On all kernels I've tested from after your patch was committed, I can
> reproduce a problem where a single high-priority thread which wakes up
> very frequently can artificially inflate the SMP balancer's load
> average for one CPU, causing other tasks to be migrated off that
> CPU. The result is that this high-priority thread (which may only use
> a few percent CPU) gets an entire CPU to itself. Even if there are
> several busy-looping threads running, this CPU will be mostly idle.

I am a bit at a loss as to how this could relate to the patch. This looks 
like a load balance logic issue that causes the load calculation to go 
wrong?


