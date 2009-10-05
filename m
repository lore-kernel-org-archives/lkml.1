Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZJEOOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZJEOOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZJEOOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:14:11 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:50750 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbZJEOOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:14:10 -0400
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for CPU"
Date: Mon, 5 Oct 2009 16:13:31 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
References: <200910051500.55875.elendil@planet.nl>
In-Reply-To: <200910051500.55875.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910051613.32631.elendil@planet.nl>
X-OriginalArrivalTime: 05 Oct 2009 14:13:32.0617 (UTC) FILETIME=[052D3390:01CA45C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Frans Pop wrote:
> With .32-rc3 I'm getting occasional skips from amarok while playing
> music from an NFS share (3 today so far), something I've not had in a
> long time.
>
> The reason looks to be that latencytop consistently shows 'iwlagn' as
> the top affected process with "Scheduler: waiting for CPU".
> Values of 100-140 ms occur frequently, but I've also seen higher values
> (180, 207). I don't remember seeing iwlagn high in the list before, but
> I have not checked earlier kernels yet.
>
> Added to that 'phy0' also frequently shows high with values of 25-75 ms.
>
> The system is otherwise essentially idle. Other processes typically show
> a latency < 5 ms.

If I give the system some work to do (like compiling a kernel), the 
latencies on iwlagn and phy0 disappear (values < 5 ms).
Is this related to ondemand frequency scaling?
