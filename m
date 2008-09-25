Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYIYSPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYIYSPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYIYSPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:15:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYIYSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:15:18 -0400
Message-ID: <48DBD519.6030204@zytor.com>
Date: Thu, 25 Sep 2008 11:14:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 -tip 0/4] x86: signal handler improvement
References: <48DBD396.5020103@ct.jp.nec.com>
In-Reply-To: <48DBD396.5020103@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> 
> and errors in __put_user is stored to stack.
> At the end of function, all errors in stack are calculated. If access to user
> space is failed, %edx is set to -EFAULT in exception handler and stored to
> stack for later operation.
> It seems inefficient.
> 

This is a gcc failure, and should be reported to the gcc people.

	-hpa
