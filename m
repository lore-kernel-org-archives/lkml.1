Return-Path: <linux-kernel-owner+w=401wt.eu-S932489AbYBUMl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbYBUMl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbYBUMlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:41:19 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:2795 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbYBUMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:41:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OE/4YrYyHgVYyhP4y2J4qDQXcV07PzLJ1ycAbrJVd9yGQ/cf3dMfnx2kMCNfW9XXdqt35wN6OuPSPAsPRvN00s4kqo/f8AzsA7Nf9EcCND7KQUbJmddZlzt0OhFQzlXT3/30DBMVQ+5tv7y1hdWuSsuGu5bziLZ7vR9VvOuJfAw=
Message-ID: <2f11576a0802210441n5912ddcfne45138c52e77c159@mail.gmail.com>
Date: Thu, 21 Feb 2008 21:41:15 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "minchan Kim" <barrioskmc@gmail.com>
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <44c63dc40802210429y24757a34p2cc8093a2db6181a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220181447.6444.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40802200149r6b03d970g2fbde74b85ad5443@mail.gmail.com>
	 <20080220185648.6447.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40802210138s100e921ekde01b30bae13beb1@mail.gmail.com>
	 <2f11576a0802210255k1e3acad7n87814e916fd24509@mail.gmail.com>
	 <44c63dc40802210429y24757a34p2cc8093a2db6181a@mail.gmail.com>
X-Google-Sender-Auth: a2935adf2880c512
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  >  please repost question with change subject.
>  >  i don't know reason of vanilla kernel behavior, sorry.
>
>  Normally, embedded linux have only one zone(DMA).
>
>  If your patch isn't applied, several processes can reclaim memory in parallel.
>  then, DMA zone's pages_scanned is suddenly increased largely. Because
>  embedded linux have no swap device,  kernel can't stop to scan lru
>  list until meeting page cache page. so if zone->pages_scanned is
>  greater six time than lru list pages, kernel make the zone with
>  unreclaimable state, As a result, OOM will kill it, too.

sorry, my last mail is easy confusious.
if you want discuss vanilla kernel bug, you shold post mail by another thread.
if not, your mail is only readed by few people.

Thanks.
