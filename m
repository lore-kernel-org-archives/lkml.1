Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZAHHF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZAHHF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZAHHFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:05:47 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:12312 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZAHHFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:05:46 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXJ75kzIpbGSp3DP
Message-ID: <4965A5C9.9070201@hartkopp.net>
Date: Thu, 08 Jan 2009 08:05:45 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <87mye2yg8a.fsf@basil.nowhere.org> <20090108023111.GJ3164@didacte.laptop.org> <20090108031042.GQ496@one.firstfloor.org>
In-Reply-To: <20090108031042.GQ496@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Jan 07, 2009 at 09:31:11PM -0500, Michael Stone wrote:
>   
>>   * so far as I know, netfilter is only commonly used to filter IP traffic. 
>>   Can
>>     I really use it to limit connections to abstract unix sockets?
>>     
>
> No you can't. But is that really your requirement? Why limiting Unix
> sockets and not e.g. named pipes? Unix sockets do not talk to the network.
>
> I suppose I don't understand your requirements very well.
>   

I think it would be very interesting for PF_CAN sockets also.
CAN has no IP at all and the suggested idea of 'self-limiting' a user 
process to use only the already open sockets could be a way to address 
the use-cases Michael stated in his RFC.

Regards,
Oliver
