Return-Path: <linux-kernel-owner+w=401wt.eu-S1761769AbYEEU2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769AbYEEU2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYEEU2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:28:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:16156 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYEEU23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=E3B5R+H2rwyTOBbZETIsc4/t2El3zaBk3Xfhdei6wrnNRM1vbWPQaBRae6nbLRr2yjcbdvhmfeIeuQ17lDvEonSJ+iZb/rpEbCnZFgUf3HhqMRimaTsJegjjdQ4j6W8VhTAkVcYaQXM388kZQM/ZUEiR+C9/lKvBUx+VOTqRop8=
Message-ID: <2f11576a0805051328o4de43786h9822d5baa594a93b@mail.gmail.com>
Date: Tue, 6 May 2008 05:28:25 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] mm/hugetlb.c: fix duplicate variable
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080505201927.GB1544@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505182816.GN17139@cs181133002.pp.htv.fi>
	 <2f11576a0805051311m60c0dfb5k56c04d5f4ddc04e8@mail.gmail.com>
	 <20080505201927.GB1544@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: b61e78acc16c5d89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > two?
>  > I think removal inner variable is 1, no?
>
>  Two people for whom English is not the native language are trying to
>  understand each other...  ;)
>
>  There were two variables.
>
>  And my patch removes the inner one inside the loop, not the outer one
>  that is valid within the whole function.

Ah, sorry.
I had misunderstanded.

you are right :)
