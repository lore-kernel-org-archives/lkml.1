Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYBASSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYBASSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYBASSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:18:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYBASSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:18:35 -0500
Message-ID: <47A36279.90606@redhat.com>
Date: Fri, 01 Feb 2008 13:18:33 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: veerasena reddy <veerasena_b@yahoo.co.in>
CC: "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: how to get chance for user space process even when the kernel
 is utilizing 100% CPU.
References: <269793.73556.qm@web8403.mail.in.yahoo.com>
In-Reply-To: <269793.73556.qm@web8403.mail.in.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

veerasena reddy wrote:
> I have a requirement where i need to execute a user process even when
> the kernel is utilizing 100% of CPU time.

In the realtime kernel, hardware interrupt handlers are prioritized 
threads, so you can give the userspace process a higher realtime priority.

	-- Chris
