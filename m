Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZDOKmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZDOKmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZDOKmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:42:32 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:40801 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZDOKmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:42:31 -0400
Message-ID: <49E5BA13.7000501@cosmosbay.com>
Date: Wed, 15 Apr 2009 12:42:27 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: panic on rmmod of nf_conntrack_irc
References: <20090410191736.21efab8c@mako-desktop> <49E4744D.5090205@trash.net> <49E47C2D.1050508@cosmosbay.com> <49E5B66D.30602@trash.net>
In-Reply-To: <49E5B66D.30602@trash.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 15 Apr 2009 12:42:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy a écrit :
> Eric Dumazet wrote:
>> I should have used different fields names (from "next", "first", ...)
>> to catch this
>> kind of errors at compile time :(
>>
>> Something like :
>>
>> diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
> 
> Eric, on second thought, could you please resubmit this to Dave?
> It touches too many files outside of netfilter to go through my
> tree.
> 
> 

Sure, but its a cleanup (and was an RFC to show my point)
so should wait a litle bit until David opens his -next tree (for 2.6.31)

Please just submit your patch for 2.6.30 ?


