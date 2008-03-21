Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbYCUQKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbYCUQKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYCUQKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:10:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48331 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYCUQKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:10:22 -0400
Message-ID: <47E3DDD1.2010601@pobox.com>
Date: Fri, 21 Mar 2008 12:09:53 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] forcedeth: fix locking bug with netconsole
References: <20080321155213.GA22755@elte.hu>
In-Reply-To: <20080321155213.GA22755@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: forcedeth: fix locking bug with netconsole
> From: Ingo Molnar <mingo@elte.hu>
> 
> while using netconsole on forcedeth, lockdep noticed the following
> locking bug:
[...]
> the fix is to disable/restore irqs instead of disable/enable.

So we make _the_ TX fast path slower, to accomodate a path that is 
rarely executed?

That seems like the wrong fix to me.

	Jeff



