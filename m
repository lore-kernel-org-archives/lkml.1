Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYKQHD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYKQHD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKQHDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:03:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:46430 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYKQHDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:03:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kQ/KtIIwul1F6qBAFxYHimx6xhEE/oSqTYM37X9BVwgCX2QiA4o9VnwWl8ikdSoA6P
         4O6zJtSM8/YwcVkh7b+TgebdCinMTynaGurYda3CUOl4bzEbsJTwBbEa7rNP8ySz70y6
         IdzL6/+i4gp90QocEd0fhJUUaMRdKnRlc6Gu8=
Message-ID: <2f11576a0811162303t51609098o6cd765c04d791581@mail.gmail.com>
Date: Mon, 17 Nov 2008 16:03:48 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: evict streaming IO cache first
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081115210039.537f59f5.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org>
	 <49208E9A.5080801@redhat.com>
	 <20081116204720.1b8cbe18.akpm@linux-foundation.org>
	 <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com>
	 <20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com>
X-Google-Sender-Auth: 903c28f48100b2f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> then, few anon pages swaped out althouth memory pressure isn't so heavy.
>>
> "few" ?
> 85Mbytes of used swap while 1.2GBytes of free memory in Gene Heskett's report.
> Hmm..

because accumuration of a days.


> How about resetting zone->recent_scanned/rotated to be some value calculated from
> INACTIVE_ANON/INACTIVE_FILE at some time (when the system is enough idle) ?

in get_scan_ratio()
