Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZIOMiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZIOMiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZIOMiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:38:09 -0400
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:26766 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZIOMiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:38:08 -0400
X-IronPort-AV: E=Sophos;i="4.44,390,1249257600"; 
   d="scan'208";a="58174618"
Cc: "Roland Dreier (rdreier)" <rdreier@cisco.com>,
       "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
       "Brice Goglin" <Brice.Goglin@inria.fr>, <linux-rdma@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>,
       <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>
Message-Id: <003720AA-6630-4718-B7F9-8392A8422220@cisco.com>
From: Jeff Squyres <jsquyres@cisco.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20090915155231.DB86.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Tue, 15 Sep 2009 08:38:08 -0400
References: <20090911064019.GZ4973@obsidianresearch.com> <adaljklifkt.fsf@cisco.com> <20090915155231.DB86.A69D9226@jp.fujitsu.com>
X-Mailer: Apple Mail (2.936)
Authentication-Results: rtp-dkim-1; header.From=jsquyres@cisco.com; dkim=pass (
	sig from cisco.com/rtpdkim1001 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 15, 2009, at 3:03 AM, KOSAKI Motohiro wrote:

>  - I guess you have your MPI implementaion w/ ummunotify, right?
>  - I guess you have test sevaral pattern, right?
>    if so, can we see your test result?
>


Roland's answers to the rest of these questions were spot-on, so I  
thought I'd just throw in a quick reply to the above questions: yes,  
we have a prototype Open MPI implementation with code that uses  
ummunotify (http://bitbucket.org/jsquyres/ummunot/).  I just finished  
fixing a high-priority (but unrelated) bug in Open MPI, so merging the  
prototype ummunotify code into the upstream Open MPI repository is now  
at the top of my priority list.

We have done quite a bit of testing with ummunotify, but since the  
code is not yet in the Open MPI mainline, most of the testing has been  
manual (not through our automated testing system).  As far as we can  
tell, everything is working properly with Open MPI + ummunotify.  We  
also anticipate that other MPI implementations will be able to use  
ummunotify, potentially using Open MPI as a reference ummunotify  
implementation.

FWIW: we went through a bunch of design and implementation iterations  
with Roland to get code that everyone was happy with:

- Roland likes it (and anticipated that the kernel community would be  
receptive to)
- we like it
- performs correctly

Hope that helps.

-- 
Jeff Squyres
jsquyres@cisco.com

