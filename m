Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXE3XOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXE3XOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXE3XOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:14:07 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:52871 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXE3XOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:14:05 -0400
X-IronPort-AV: i="4.14,595,1170662400"; 
   d="scan'208"; a="489488101:sNHT45271474"
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>, axboe@kernel.dk,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] drivers/block/ub.c: use list_for_each_entry()
X-Message-Flag: Warning: May contain useful information
References: <20070530084752.GE14284@traven>
	<20070530123840.e54d73c2.zaitcev@redhat.com>
	<a781481a0705301414t4a0c1b2epe5e14b62ec8dc872@mail.gmail.com>
	<20070530160850.0c536d55.zaitcev@redhat.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 May 2007 16:14:01 -0700
In-Reply-To: <20070530160850.0c536d55.zaitcev@redhat.com> (Pete Zaitcev's message of "Wed, 30 May 2007 16:08:50 -0700")
Message-ID: <adasl9dq4zq.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 May 2007 23:14:01.0692 (UTC) FILETIME=[359219C0:01C7A310]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The negative is the sheer number of helper functions in list.h. Personally,
 > I find it difficult to retain a working knowledge of them. Iterators are
 > particularly nasty that way. I'm thinking about dropping all of these
 > list_for_each_with_murky_argument_requirements_and_odd_side_effects()
 > and use plain for(;;), as a courtesy to someone who has to read the
 > code years down the road.

I think I disagree with this reasoning.  If I'm reading your code and
I see, say, list_for_each_entry_safe(), I can be pretty confident that
your loop works correctly.  If you write your own for loop, then I
have to check that you actually got the linked list walking right.

 - R.
