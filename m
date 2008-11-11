Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYKKXDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYKKXDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYKKXDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:03:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39570 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYKKXDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:03:19 -0500
Message-ID: <491A0F17.2070706@redhat.com>
Date: Wed, 12 Nov 2008 01:02:47 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>	<1226409701-14831-2-git-send-email-ieidus@redhat.com>	<1226409701-14831-3-git-send-email-ieidus@redhat.com>	<1226409701-14831-4-git-send-email-ieidus@redhat.com>	<20081111150345.7fff8ff2@bike.lwn.net>	<491A0483.3010504@redhat.com> <20081111153028.422b301a@bike.lwn.net>
In-Reply-To: <20081111153028.422b301a@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
>
> What about things like cache effects from scanning all those pages?  My
> guess is that, if you're trying to run dozens of Windows guests, cache
> usage is not at the top of your list of concerns, but I could be
> wrong.  Usually am...
>   

Ok, ksm does make the cache of the cpu dirty when scanning the pages
(but the scanning happen slowly slowly and cache usually get dirty much 
faster)
But infact it improve the cache by the fact that it make many ptes point 
to the same page
so if before we had 12 process touching 12 diffrent physical page they 
would dirty the page
but now they will touch just one...

so i guess it depend on how you see it...

> Thanks,
>
> jon
>   

