Return-Path: <linux-kernel-owner+w=401wt.eu-S932219Ab0AMUkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0AMUkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205Ab0AMUkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:40:43 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:65493 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab0AMUkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:40:41 -0500
Date: Wed, 13 Jan 2010 15:39:37 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
In-reply-to: <4B48CC2C.2090403@majjas.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <4B4E2F89.2050606@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B4625BD.3070202@majjas.com> <20100107183545.GA3208@del.dom.local>
 <4B462B3C.90506@majjas.com> <20100107185040.GB3208@del.dom.local>
 <4B466A26.5070506@majjas.com> <20100108074539.GA6205@ff.dom.local>
 <4B475FF9.7000702@majjas.com> <20100108212923.GA3078@del.dom.local>
 <4B47A81B.5040601@majjas.com> <4B4809EF.1070609@majjas.com>
 <20100109122830.GA4386@del.dom.local> <4B48CC2C.2090403@majjas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2010 1:34 PM, Michael Breuer wrote:
> On 1/9/2010 7:28 AM, Jarek Poplawski wrote:   ...
>> It looks like DMAR is the main candidate for a new linux-kernel@ or
>> bugzilla bug report. You should also consider reporting these ipv6
>> problems, especially if you think they can trigger TX timeouts. (In
>> both cases it would be good to try current mainline first, when you
>> get it workable.)
> Ok - I'll get onto mainline and then deal with DMAR.
Just an FYI - 2.6.32.3 with alt 3 af_packet patch & sky2 pskb_may_pull 
runs OK with DMAR (re)enabled and msi enabled.
>> Thanks,
>> Jarek P.
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

