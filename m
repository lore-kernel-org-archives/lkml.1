Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZKMKt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZKMKt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZKMKtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:49:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbZKMKty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:49:54 -0500
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
From: Peter Zijlstra <peterz@infradead.org>
To: ego@in.ibm.com
Cc: Sachin Sant <sachinp@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <1258108281.22655.5.camel@laptop>
References: <20091112195101.63263490.sfr@canb.auug.org.au>
	 <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop>
	 <4AFBFE3D.80507@in.ibm.com> <1258028831.4039.152.camel@laptop>
	 <1258045831.4039.736.camel@laptop>  <20091113095801.GA29977@in.ibm.com>
	 <1258107368.4039.1149.camel@laptop>  <1258108281.22655.5.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 11:49:49 +0100
Message-ID: <1258109389.22655.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 11:31 +0100, Peter Zijlstra wrote:
> /me goes try a PREEMPT=n kernel, since that is what Mike reports boot
> funnies with..

Seems to boot just fine..

let me run a few benchmarks while I have:

while :; 
do
	echo 0 > /sys/devices/system/cpu/cpu1/online; 
	sleep .1;
	echo 1 > /sys/devices/system/cpu/cpu1/online;
done &

running

