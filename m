Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbZCRQ66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbZCRQ66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbZCRQ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:58:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:36447 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbZCRQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=OCEtxjmro5wAcR7xmXnMCKEQUV0lA2GZU8KPHdFK2g7dWBHSXK9PEXeFP6Dq1ugiN/
         mKj5rvTZwpQVJycHlJfNhDa1acOFKJqFw/9obqf3o1Ou/ez/xIosZn8xryzCc1O2fJ8g
         gPqvVnuRd4PxyG41maLPgv4AGsWw/dzpR81CQ=
MIME-Version: 1.0
In-Reply-To: <a4423d670903180734w7270a4f3qa2af3981b969436c@mail.gmail.com>
References: <a4423d670903180734w7270a4f3qa2af3981b969436c@mail.gmail.com>
Date: Wed, 18 Mar 2009 19:58:40 +0300
Message-ID: <a4423d670903180958j4847717eh99a41534633dd314@mail.gmail.com>
Subject: Re: next-20090318: sunhme does not transmit packets
From: Alexander Beregalov <a.beregalov@gmail.com>
To: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/18 Alexander Beregalov <a.beregalov@gmail.com>:
> Hi
>
> Ultra 10 can boot, it receives DHCP answer, ssh works, but few minutes
> after machine becomes unresponsible by net at all.
> It does not respond even on ARP requests.
>
> On Sparc host I see that `TX packets` does not grow, but RX grows.
> The state of the interface is
> UP BROADCAST RUNNING MULTICAST
>
> There is no relevant kernel messages in dmesg.
>
> next-20090317 worked fine.
>
>
> Let me know if I can help.
>

I have reproduced it on next-20090318 for the second time, but still
do not know how.
next-20090317 might be affected.

Now both packet counters grow, but tcpdump cannot capture any packet.
