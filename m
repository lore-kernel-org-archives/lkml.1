Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbYKSToU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbYKSToU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYKSToI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:44:08 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:52478 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYKSToG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:44:06 -0500
Date: Wed, 19 Nov 2008 13:43:12 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <20081117090648.GG28786@elte.hu>
Message-ID: <Pine.LNX.4.64.0811191341570.23502@quilx.com>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera>
 <20081117090648.GG28786@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Ingo Molnar wrote:

> Christoph, as per the recent analysis of Mike:
>
>  http://fixunix.com/kernel/556867-regression-benchmark-throughput-loss-a622cf6-f7160c7-pull.html
>
> all scheduler components of this regression have been eliminated.
>
> In fact his numbers show that scheduler speedups since 2.6.22 have
> offset and hidden most other sources of tbench regression. (i.e. the
> scheduler portion got 5% faster, hence it was able to offset a
> slowdown of 5% in other areas of the kernel that tbench triggers)

Ok will rerun the tests tomorrow. Just got back from SC08 need some time
to catch up.

Looks like a lot of work was done on this issue. Thanks!

