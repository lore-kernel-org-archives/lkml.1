Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXL0CsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXL0CsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 21:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXL0CsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 21:48:05 -0500
Received: from zyfb01-66.zyxel.com.tw ([59.124.183.66]:20357 "EHLO
	zyfb01-66.zyxel.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXL0CsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 21:48:04 -0500
Message-ID: <001501c84832$e4bb3d60$431a17ac@ZyXEL.com>
From: "Lewis Li" <lachang.li@zyxel.com.tw>
To: <linux-kernel@vger.kernel.org>
References: <001201c846c9$6d03de40$431a17ac@ZyXEL.com> <20071226141301.8231163b.akpm@linux-foundation.org> <23058.1198709236@death>
Subject: Re: 2 ports could not bond to a aggregator in 802.3ad mode issue 
Date: Thu, 27 Dec 2007 10:48:00 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-OriginalArrivalTime: 27 Dec 2007 02:48:00.0294 (UTC) FILETIME=[E4B8CC60:01C84832]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are right. The incorrect behavior is due to we don't setup the 
lacpdu of switch correctly.
The bonding driver is correct. Thanks for your comment!

> I do not believe so.
>
> IEEE 802.3 section 43.3.9 states, in part,
>
> "Links that are not successful candidates for aggregation (e.g.,
> links that are attached to other devices that cannot perform aggregation
> or links that have been manually configured to be non-aggregatable) are
> enabled to operate as individual IEEE 802.3 links. For consistency of
> modeling, such a link is regarded as being attached to a compatible
> Aggregator that can only be associated with a single link. That is, from
> the perspective of Link Aggregation, non-aggregated links are not a
> special case; they compose an aggregation with a maximum membership of
> one link."
>
> I do not see that it is correct to attach the links to a common
> aggregator, as your output indicates that no partner association has
> been created (the Partner MAC is all zeroes) and the links are therefore
> apparently connected to a device that cannot perform aggregation.
>
> ---
> -Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

Regards,
Lewis Li 

