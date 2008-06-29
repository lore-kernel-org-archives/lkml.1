Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbYF2MDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbYF2MDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYF2MDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:03:09 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:42052 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbYF2MC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:02:27 -0400
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jun 2008 08:02:27 EDT
Message-ID: <4867733A.3060203@fastmq.com>
Date: Sun, 29 Jun 2008 13:34:18 +0200
From: Martin Sustrik <sustrik@fastmq.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Martin Lucina <mato@kotelna.sk>, linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk> <48664F01.7060902@davidnewall.com>
In-Reply-To: <48664F01.7060902@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Martin Lucina wrote:
>> Measurement of the write(2) time is performed using the TSC, so any
>> latency there is negligible.
> 
> Measuring each write is lavish and bound to impact the results.  To
> measure sustained throughput, get the time only at start and end, and
> divide the difference by the number of writes.

Hi,

We're using RDTSC to measure time, which takes ~30 nanoseconds to 
complete. I would say this is negligible given that latency of a write 
is 5 orders of magnitude higher.

Martin

