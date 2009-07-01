Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZGAOSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZGAOSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZGAOR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:17:58 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:49450 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZGAOR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:17:57 -0400
Date: Wed, 01 Jul 2009 23:17:58 +0900 (JST)
Message-Id: <20090701.231758.128627745.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: mitake@dcl.info.waseda.ac.jp
In-Reply-To: <20090701135032.GA21069@elte.hu>
References: <20090701073139.GA12073@elte.hu>
	<20090701134501.GA5097@nowhere>
	<20090701135032.GA21069@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Date: Wed, 1 Jul 2009 15:50:32 +0200

>  
> > Which makes me think it may be better to use the existing ftrace 
> > lock events as softwares counters for that, which takes into 
> > account the following events:
> > 
> > - lock_acquire
> > - lock_release
> > - lock_contended
> > - lock_acquired
> > 
> > And these events are per lock.
> > 
> > Now the missing piece is the sampling count for events...
> 
> Yeah, this is an even better idea. It gets the acquire counts - and 
> much more.
> 

Is there another way to implement more easily?
Fortunately or unfortunately, I didn't start implementing
because my x86_64 box died suddenly :-(
So I'll need a few days to fix, sorry...

