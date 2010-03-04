Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab0CDUiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:38:13 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:59556 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab0CDUiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:38:10 -0500
Date: Thu, 4 Mar 2010 21:38:03 +0100
From: M G Berberich <berberic@fmi.uni-passau.de>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.33 dies on modprobe
Message-ID: <20100304203803.GA3267@invalid>
References: <fa.S/rvLm1aQlDSqPwVJz5B+5vHjbM@ifi.uio.no>
 <fa.+Pg2gFpQSg5k/1mCpBdt8xMXeqY@ifi.uio.no>
 <fa.0/xGeZctWXDyX0DAp6opgP1HP7w@ifi.uio.no>
 <fa.kPSENj9DWu0Q8xolQMDkRvAwxQ0@ifi.uio.no>
 <fa.JUJQsT7bECqtd8JSoNY+SBdASCE@ifi.uio.no>
 <fa.Lya/54V1PJgwjc8uy1Yk4NyYUh4@ifi.uio.no>
 <20100303230438.GA3363@invalid>
 <20100304153042.GA4614@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100304153042.GA4614@hack>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Df-Sender: 311801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 04. März schrieb Américo Wang:
> On Thu, Mar 04, 2010 at 12:04:38AM +0100, M G Berberich wrote:
> >Am Mittwoch, den 03. März schrieb Américo Wang:
> >> On Wed, Mar 3, 2010 at 5:08 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >> > On Wed, Mar 3, 2010 at 4:58 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >> >> Ok, below is my patch, I am not sure it could fix the BUG for you,
> >> >> but it could fix the WARNING. But perhaps they are related.
> >> >>
> >> >> Please give it a try.
> >> >>
> >> >
> >> > Oops! Ignore the patch, it should not be correct, I will send a
> >> > correct version soon.
> >> > Sorry.
> >> >
> >> 
> >> Here we go:
> >
> >Seems to fix the warning, but not the modprobe-Oops.
> >
> 
> Thanks much for your testing!
> 
> Could you please try to turn on DEBUG_KOBJECT and boot your kernel
> with "initcall_debug"? And then show us your dmesg.

If I'm doing this (enabled CONFIG_DEBUG_KERNEL and
CONFIG_DEBUG_KOBJECT), the kernel dies immediately - no output.

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | berberic@fmi.uni-passau.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | www.fmi.uni-passau.de/~berberic
