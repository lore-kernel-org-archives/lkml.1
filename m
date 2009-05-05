Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbZEEWWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbZEEWWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZEEWWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:22:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:43953 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbZEEWWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:22:23 -0400
Subject: Re: IO scheduler based IO Controller V2
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com
In-Reply-To: <20090505132441.1705bfad.akpm@linux-foundation.org>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
	 <20090505132441.1705bfad.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 06 May 2009 00:20:49 +0200
Message-Id: <1241562049.11059.921.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 13:24 -0700, Andrew Morton wrote:
> On Tue,  5 May 2009 15:58:27 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > 
> > Hi All,
> > 
> > Here is the V2 of the IO controller patches generated on top of 2.6.30-rc4.
> > ...
> > Currently primarily two other IO controller proposals are out there.
> > 
> > dm-ioband
> > ---------
> > This patch set is from Ryo Tsuruta from valinux.
> > ...
> > IO-throttling
> > -------------
> > This patch set is from Andrea Righi provides max bandwidth controller.
> 
> I'm thinking we need to lock you guys in a room and come back in 15 minutes.
> 
> Seriously, how are we to resolve this?  We could lock me in a room and
> cmoe back in 15 days, but there's no reason to believe that I'd emerge
> with the best answer.
> 
> I tend to think that a cgroup-based controller is the way to go. 
> Anything else will need to be wired up to cgroups _anyway_, and that
> might end up messy.

FWIW I subscribe to the io-scheduler faith as opposed to the
device-mapper cult ;-)

Also, I don't think a simple throttle will be very useful, a more mature
solution should cater to more use cases.


