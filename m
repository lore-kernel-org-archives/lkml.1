Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYHUHSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYHUHSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbYHUHSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:18:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:29753 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbYHUHSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hI1xuORFE2ALk2xrKBuMdSb/F1JI4gSUCz0R958fmot3Y01tGIaTBpGk29nkENHHc1
         cYe4p6OHa5d3YFzpPF3gYqHtRWY5fYCq8GDyaUK8QIB/UQRoOfvm7o/26bYGsce9fi8l
         4CmxHyVn4kdlKMPaH1a+2i8XeaSeaVNm/J5rY=
Message-ID: <2f11576a0808210018h157b0eddr1c327ecad8315cad@mail.gmail.com>
Date: Thu, 21 Aug 2008 16:18:00 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of CPUs
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com
In-Reply-To: <20080821.001322.236658980.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080820200709.12F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080820234615.258a9c04.akpm@linux-foundation.org>
	 <20080821.001322.236658980.davem@davemloft.net>
X-Google-Sender-Auth: c81fbb033ab4a141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> sparc64 allmodconfig:
>>
>> mm/quicklist.c: In function `max_pages':
>> mm/quicklist.c:44: error: invalid lvalue in unary `&'
>>
>> we seem to have a made a spectacular mess of cpumasks lately.
>
> It should explode similarly on x86, since it also defines node_to_cpumask()
> as an inline function.
>
> IA64 seems to be one of the few platforms to define this as a macro
> evaluating to the node-to-cpumask array entry, so it's clear what
> platform Motohiro-san did build testing on :-)

Thank you good advice.
I don't have sparc64 machine but I can get borrowing x86 machine.
So, I'll test on x86 today.
