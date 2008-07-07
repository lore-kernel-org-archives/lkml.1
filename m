Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbYGGB0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbYGGB0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 21:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757582AbYGGB0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 21:26:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:43028 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbYGGB0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 21:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UIa1o1njJpVXooKTTF7Ddd5I+vCXYM6xItBRZVKFURRnqOR3ndgtVhF/1sZdaZdeGK
         DMFoZ1cIlHBNzJ7qAn9OLR6CbMPboGEo7XaE3f/gyF5P78Js7J5KzR8pHeHLbr70MZ91
         fzbV5mXP6XnN864wfkoIGoTEI06k2Z6pLu8vY=
Message-ID: <9871ee5f0807061826r101a1aboe266a3432af650a2@mail.gmail.com>
Date: Sun, 6 Jul 2008 21:26:35 -0400
From: "Timothy Normand Miller" <theosib@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: HELP: Getting unexpected fakeraid behavior. Fix?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9871ee5f0807061822l2871765bhd92aa177c0d5d55b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9871ee5f0807061307ncc55104y477c57be3e91b75f@mail.gmail.com>
	 <20080706131937.13065312@infradead.org>
	 <9871ee5f0807061424o535c6d7eg3071da6e31e0b58e@mail.gmail.com>
	 <9871ee5f0807061822l2871765bhd92aa177c0d5d55b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was poking around some more, and I found drivers/md/raid1.c.  This
has sophisticated load balancing for reads.  Why isn't this code being
used for dm_raid1?  I'm a bit confused as to why this redundant code
should be there if dmraid and mdraid are functionally the same.


-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
