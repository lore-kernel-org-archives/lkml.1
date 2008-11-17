Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbYKQGoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbYKQGoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 01:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYKQGoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 01:44:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:43977 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYKQGoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 01:44:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=EVxx2t7P9J4LZY0vjhzPKfacQ0o9GbmmgF/f6jcyw/PD+VYZhhn/nv68Ye+MD4f1im
         dxJD3qnBOjgNPBLBCQnsRMcQKc6Oz2AnTIwwzn5FHEspp0KP8aRFgMZQ4Aul433CJfCj
         j/nNo8CBENaIYlNIDFg4EqiNspjrCinmLZ2oc=
Message-ID: <2f11576a0811162243r7527d271ya8ab2fc3a9be9f7d@mail.gmail.com>
Date: Mon, 17 Nov 2008 15:43:59 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Cc: balbir@linux.vnet.ibm.com, "Lai Jiangshan" <laijs@cn.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Dave Airlie" <airlied@gmail.com>, "David Miller" <davem@davemloft.net>,
       akpm@linux-foundation.org, menage@google.com, jens.axboe@oracle.com,
       jack@suse.cz, jes@sgi.com, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, "Alexey Dobriyan" <adobriyan@gmail.com>
In-Reply-To: <20081117142539.9b2c6bfc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491FA28B.2070003@cn.fujitsu.com>
	 <20081115205229.765f7ee3@infradead.org>
	 <20081116.001926.150424480.davem@davemloft.net>
	 <20081116105725.12458b13@infradead.org>
	 <21d7e9970811161339x174d6041x1622d478f8e4247e@mail.gmail.com>
	 <20081116135130.5e8b4e13@infradead.org>
	 <4920D238.8090905@cn.fujitsu.com> <4920F8C4.30209@linux.vnet.ibm.com>
	 <20081117142539.9b2c6bfc.kamezawa.hiroyu@jp.fujitsu.com>
X-Google-Sender-Auth: 33bb1b53acc244aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > (I'll rename simple_malloc/simple_free to kvmalloc/kvfree)
>> >
>>
>> I would prefer to find a way to say that one cannot select gfp_mask with this API.
>>
> I think gfp_mask must be passed explicitly.

Agreed.
