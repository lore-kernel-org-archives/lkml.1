Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbZFSWip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbZFSWip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760235AbZFSWed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:34:33 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:1026 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760213AbZFSWec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:34:32 -0400
Message-ID: <4A3C1279.6040506@athenacr.com>
Date: Fri, 19 Jun 2009 18:34:33 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: gettimeofday() time warps on Nehalem
References: <4A3BAAE8.3030606@athenacr.com>
In-Reply-To: <4A3BAAE8.3030606@athenacr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Bloniarz wrote:
> $ ./time-warp-test
> 16 CPUs, running 16 parallel test-tasks.
> checking for time-warps via:
> - gettimeofday (TOD) syscall (usec resolution)
> 
> new TOD-warp maximum:        -1 usecs,  00046cb465acb046 -> 00046cb465acb045
> new TOD-warp maximum:        -2 usecs,  00046cb465ad7515 -> 00046cb465ad7513
> TOD: 0.26us, fail:21534 \

Ignore this. I killed NTP before running these tests, but
it looks now like a script from my distro restarted it.

I can no longer reproduce the problem, sorry for the noise.

Thanks,
-Brian
