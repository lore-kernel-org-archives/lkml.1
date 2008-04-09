Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYDIOar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYDIOar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYDIOaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:30:39 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:2185 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYDIOai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:30:38 -0400
Date: Wed, 09 Apr 2008 08:31:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Plenty of inactive memory
In-reply-to: <fa.HIr5TAepu3mcAI6oLfBPL3wGwss@ifi.uio.no>
To: Andreas Grimm <agrimm61@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <47FCD324.8030100@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.HIr5TAepu3mcAI6oLfBPL3wGwss@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Grimm wrote:
> Hello everybody,
> 
> i got a weird problem with one of my servers. It's a Intel SR2500AL
> with 32GB of RAM.
> Looking at the memory usage of the system, something is going totally
> wrong. The crucial numbers from /proc/meminfo are:
> 
> MemTotal: 33265916 kB
> MemFree: 416168 kB
> Inactive: 24630428 kB (24GB? whooaaa)
> 
> Another system with only 16GB, same amount of users and load, shows a
> more normal behaviour:
> 
> MemTotal: 16619808 kB
> MemFree: 6912676 kB
> Inactive: 1774364 kB
> 
> Why does the 32GB-System have this plenty of inactive memory. Is there
> a way to find out, what the kernel is holding in readiness?
> 
> OS: SLES 10 SP1
> Kernel : 2.6.16.27-0.9-bigsmp
> 
> Thanks in advance.

Doesn't sound unreasonable that most of that memory is not in active 
use, depending on the applications..
