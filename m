Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbZAHTez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbZAHTez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZAHTep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:34:45 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:16857 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZAHTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uCis0WFTQR/sfrkulHjOjjWfh3i8wIumnv9iw1iqHVczJe49Gf/EDUa/jpJW1KA/3g
         qFg0CYx7fNVe+j7TYbq1zeU4a1cinB3Cp5Em4MzMMo9e/nVQlfBs4gUWOIMzXMJ0QqWp
         Gea1Hv91U+Hm6z9Rr40fqqE4jrafugvt4Vezw=
Message-ID: <8bd0f97a0901081134gc5b6eb9h7f20dea146fc6cd0@mail.gmail.com>
Date: Thu, 8 Jan 2009 14:34:43 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/2] netdev: bfin_mac: enable VLAN support in Blackfin MAC driver
Cc: cooloney@kernel.org, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, graf.yang@analog.com
In-Reply-To: <20090108.113009.263402475.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090108.105531.176161465.davem@davemloft.net>
	 <8bd0f97a0901081101t6fdfa485rbd7ccc4e47691ddb@mail.gmail.com>
	 <8bd0f97a0901081105q1e897254kad9a8533b5845403@mail.gmail.com>
	 <20090108.113009.263402475.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 14:30, David Miller wrote:
> From: "Mike Frysinger" <vapier
>> On Thu, Jan 8, 2009 at 14:01, Mike Frysinger wrote:
>> > On Thu, Jan 8, 2009 at 13:55, David Miller wrote:
>> >> We can get VLAN packets received and sent, using AF_PACKET
>> >> sockets, for example.  The chip should still respect those
>> >> even if VLAN proper is not being utilized.
>> >
>> > any tips on doing that ?
>>
>> or rather, is there a driver or you two you can point out that is
>> doing this correctly ?  the ones i looked at seemed to be doing it
>> like the patch we posted ...
>
> And I disagree with how those drivers are doing it :-)
>
> At least the programming of the chip to accept all packet
> types properly, VLAN or not, regardless of kernel config,
> is definitely IMHO the way to go.

i know on our side we all agree with you, we just didnt (dont) know
any better ;)
-mike
