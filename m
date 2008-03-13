Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbYCMSRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbYCMSRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYCMSRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:17:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47373 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYCMSRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:17:08 -0400
Subject: Re: 2.6.25-rc5-mm1 - x86_64 boot problem with git-sched.patch
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <3d8471ca0803131055w247386e7g9bbea665bf78ca6e@mail.gmail.com>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <1205345451.23611.6.camel@dyn9047017100.beaverton.ibm.com>
	 <20080312111509.301c9d24.akpm@linux-foundation.org>
	 <1205428180.19403.15.camel@dyn9047017100.beaverton.ibm.com>
	 <1205430028.19403.19.camel@dyn9047017100.beaverton.ibm.com>
	 <3d8471ca0803131055w247386e7g9bbea665bf78ca6e@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 10:20:09 -0800
Message-Id: <1205432409.19403.24.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 18:55 +0100, Guillaume Chazarain wrote:
> On Thu, Mar 13, 2008 at 6:40 PM, Badari Pulavarty <pbadari@us.ibm.com> wrote:
> >  commit 60befbc1c0b6d141c9c26e61ddd303aedd1e7396
> >  Author: Guillaume Chazarain <guichaz@yahoo.fr>
> >  Date:   Mon Mar 10 08:16:41 2008 +0100
> >
> >     sched: make sure jiffies is up to date before calling
> >  __update_rq_clock()
> 
> I didn't know this patch could prevent booting, but anyway it should
> have been removed a long time ago:
> http://lkml.org/lkml/2008/1/25/408
> 

I don't know whats happening either, but my debug shows that 
tick_nohz_update_jiffies() always returns due to following
check without calling touch_softlockup_watchdog().

        if (!ts->tick_stopped)
                return;

BTW, I have CONFIG_DETECT_SOFTLOCKUP=y in my config.


Thanks,
Badari        

