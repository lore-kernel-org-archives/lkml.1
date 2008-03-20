Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYCTH60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYCTH60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYCTH6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:58:09 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:64957 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYCTH6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eFLKCJuaeYoHNJTMPvtFjj7BuzwP8hspe4FVSIrJRtDFf3bk3WwpvVHs7Nxr1IKhvFFJ6JI7O1IEq78LCN3OO8j3RjAXAg6VUoSZ4yzjnf2iZ7p+Y0JQ2Hc5FIAyJiRuUfFYtG97cSlvpNY8+Oyt8H1HhLNbQDapOQ0njwKP1ok=
Message-ID: <2f11576a0803200058k4ee85bf1se6abe272c496c39d@mail.gmail.com>
Date: Thu, 20 Mar 2008 16:58:07 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
Subject: Re: [BUG?] 2.6.25-rc[23]-mm1 cgroup list corruption under load with VM Scalability patches
Cc: "Paul Menage" <menage@google.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1205863811.5032.26.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204745828.6244.31.camel@localhost>
	 <6599ad830803051309g22d5b746ta30c4f28a394572c@mail.gmail.com>
	 <1205863811.5032.26.camel@localhost>
X-Google-Sender-Auth: f20f87bbe9009692
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

CC'ed KAMEZAWA-san

>  > > list_del corruption in cgroup_exit() on 16 cpu, 32GB ia64 NUMA platform.
>  > >
>  > >  I've been seeing this for a while now, but we've had known problems
>  > >  [page leaks, ...] with the VM scalability series.  Now the system
>  > >  appears to be running very well with these patches under stress loads
>  > >  that would hang it or cause OOM kill of tests with plenty of swap space
>  > >  left.  Eventually, [after 40-45 minutes], I hit a list corruption in
>  > >  cgroup_exit().
>  > >
>  > >  I can't say for sure that our patches aren't causing this, but I've been
>  > >  unable to keep the system up long enough under the stress load w/o the
>  > >  splitlru+noreclaim patches to hit the problem.

sorry for late responce, I don't notice this thread.
fujitsu guys investigated that problem too.

AFAIK this problem already fixed KAMEZAWA-san.
but I don't know that patch merged -mm or not.

kamezawa-san, please let us know its status?
