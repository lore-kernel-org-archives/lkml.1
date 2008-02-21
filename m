Return-Path: <linux-kernel-owner+w=401wt.eu-S1763221AbYBUKzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763221AbYBUKzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 05:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbYBUKzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 05:55:43 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:39219 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYBUKzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 05:55:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jEWZ7ZLjMB8+T5k8R6PfOYZmSv8BYJwVlfx7RJ1zzuxUVTLXL1dyy3iO0SC1GLkS+cFE2y7y0ggfGUWtnOpIjzF8TlybiSmhM4xb4YeUSpAZtkRSTHGggmfB5fZ61Or06+z7hcXfiI6ZTfffDyFKuRiOAEKVKA2jYojg85HS2PE=
Message-ID: <2f11576a0802210255k1e3acad7n87814e916fd24509@mail.gmail.com>
Date: Thu, 21 Feb 2008 19:55:39 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "minchan Kim" <barrioskmc@gmail.com>
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <44c63dc40802210138s100e921ekde01b30bae13beb1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220181447.6444.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40802200149r6b03d970g2fbde74b85ad5443@mail.gmail.com>
	 <20080220185648.6447.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40802210138s100e921ekde01b30bae13beb1@mail.gmail.com>
X-Google-Sender-Auth: b419cd64eb479048
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim-san,

Thank you very much.
btw, what different between <test 1> and <test 2>?

>  It was a very interesting result.
>  In embedded system, your patch improve performance a little in case
>  without noswap(normal case in embedded system).
>  But, more important thing is OOM occured when I made 240 process
>  without swap device and vanilla kernel.
>  Then, I applied your patch, it worked very well without OOM.

Wow, it is very interesting result!
I am very happy.

>  I think that's why zone's page_scanned was six times greater than
>  number of lru pages.
>  At result, OOM happened.

please repost question with change subject.
i don't know reason of vanilla kernel behavior, sorry.
