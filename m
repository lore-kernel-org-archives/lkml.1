Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbXIKOHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbXIKOHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXIKOGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:06:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbXIKOGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:06:40 -0400
Message-ID: <46E6A097.6060508@redhat.com>
Date: Tue, 11 Sep 2007 10:05:11 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND 2][PATCH 0/4] Virtual Machine Time Accounting
References: <46E550D7.6090805@bull.net> <20070910194143.GA6052@elte.hu>
In-Reply-To: <20070910194143.GA6052@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Laurent Vivier <Laurent.Vivier@bull.net> wrote:
> 
>> This new version remove conditional compilation on GUEST_ACCOUNTING.
> 
> excellent! For all 4 patches:
> 
>  Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> i'd suggest inclusion into 2.6.24.
> 
> can the /proc change break anything? Any old procps version perhaps?

We have added numbers to the cpu lines in /proc/stat since
early 2.6.  All the programs parsing /proc/stat should just
scan for a number of numbers from the start of the line, without
trying to scan for the terminating newline.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
