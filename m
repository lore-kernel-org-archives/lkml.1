Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZCSIQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZCSIQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZCSIQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:16:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:37248 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZCSIQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K1rt1+qXBmjRj+BJBYuRmosoSsxYcJS88BOiPbWMfMHX/ed/C3dd3o9EB6qR+Nc5iq
         82yBG6EcBrngL7qwozQIwHwO6NcSRNtTr6dheEWZCpZWdvGg6V2R1TPyg/ijAAlNRlWv
         cW2RVSqziUvAN/oTMHG//zjag70Vt8ClMsVO8=
MIME-Version: 1.0
In-Reply-To: <20090318.234451.38898787.davem@davemloft.net>
References: <a4423d670903180734w7270a4f3qa2af3981b969436c@mail.gmail.com>
	 <a4423d670903180958j4847717eh99a41534633dd314@mail.gmail.com>
	 <20090318.234451.38898787.davem@davemloft.net>
Date: Thu, 19 Mar 2009 11:16:20 +0300
Message-ID: <a4423d670903190116p157b2ebfl69d270e0576c6d9a@mail.gmail.com>
Subject: Re: next-20090318: sunhme does not transmit packets
From: Alexander Beregalov <a.beregalov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/19 David Miller <davem@davemloft.net>:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> Date: Wed, 18 Mar 2009 19:58:40 +0300
>
>> 2009/3/18 Alexander Beregalov <a.beregalov@gmail.com>:
>> > Hi
>> >
>> > Ultra 10 can boot, it receives DHCP answer, ssh works, but few minutes
>> > after machine becomes unresponsible by net at all.
>> > It does not respond even on ARP requests.
>> >
>> > On Sparc host I see that `TX packets` does not grow, but RX grows.
>> > The state of the interface is
>> > UP BROADCAST RUNNING MULTICAST
>> >
>> > There is no relevant kernel messages in dmesg.
>> >
>> > next-20090317 worked fine.
>> >
>> >
>> > Let me know if I can help.
>> >
>>
>> I have reproduced it on next-20090318 for the second time, but still
>> do not know how.
>> next-20090317 might be affected.
>>
>> Now both packet counters grow, but tcpdump cannot capture any packet.
>
> Does the current vanilla kernel work fine?

Yes. The problem happens only with -next tree.
