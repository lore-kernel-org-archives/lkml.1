Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbXGFPs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbXGFPs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762275AbXGFPsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:48:09 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:62784 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762104AbXGFPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:48:08 -0400
Message-ID: <468E6402.2000507@nortel.com>
Date: Fri, 06 Jul 2007 09:47:14 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ernie Petrides <petrides@redhat.com>,
       Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <200707052312.l65NCjfb025915@pasta.boston.redhat.com> <1183699046.3289.51.camel@chaos>
In-Reply-To: <1183699046.3289.51.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2007 15:47:18.0524 (UTC) FILETIME=[EEEBFBC0:01C7BFE4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> It needs a running smp_call_function() to be interrupted by the timer
> interrupt, which calls clock_was_set(). So it's not that easy to
> reproduce.

On our 2.6.10-based kernel its basically trivial to reproduce, and the 
posted fix doesn't solve the issue.

One of our guys is trying to track it down. As yet we don't know if it's 
the vanilla code or the patches on top that contain the bug.

Chris
