Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZEEUiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZEEUiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZEEUig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:38:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476AbZEEUig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:38:36 -0400
Date: Tue, 5 May 2009 13:24:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com
Subject: Re: IO scheduler based IO Controller V2
Message-Id: <20090505132441.1705bfad.akpm@linux-foundation.org>
In-Reply-To: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 May 2009 15:58:27 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> 
> Hi All,
> 
> Here is the V2 of the IO controller patches generated on top of 2.6.30-rc4.
> ...
> Currently primarily two other IO controller proposals are out there.
> 
> dm-ioband
> ---------
> This patch set is from Ryo Tsuruta from valinux.
> ...
> IO-throttling
> -------------
> This patch set is from Andrea Righi provides max bandwidth controller.

I'm thinking we need to lock you guys in a room and come back in 15 minutes.

Seriously, how are we to resolve this?  We could lock me in a room and
cmoe back in 15 days, but there's no reason to believe that I'd emerge
with the best answer.

I tend to think that a cgroup-based controller is the way to go. 
Anything else will need to be wired up to cgroups _anyway_, and that
might end up messy.

