Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbYBZWgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbYBZWgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765155AbYBZWgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:36:25 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:8861 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765488AbYBZWgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:36:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q3k3rD0JIwjzNUx6b6JzibPL1XPre4XCqFv3snLtwFvOjfm32IezM3OXVRT0PfOoVxy91celSRh+d7d1Z3RVuG3GQHti9zAI0ejTanRo2DpgWkXgovhN5S83NT4AQf0kCi8m9pWNzmwfWwuaiYTVGcGDQmDCnHgSAbm4sWb80aY=
Message-ID: <c6b1100b0802261436i7c5a4136j753501933037187@mail.gmail.com>
Date: Tue, 26 Feb 2008 22:36:19 +0000
From: "Chris Clayton" <chris2553@googlemail.com>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Cc: linville@tuxdriver.com, ivdoorn@gmail.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, johannes@sipsolutions.net
In-Reply-To: <20080226223814.4ef2b435@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <200802252104.32416.chris2553@googlemail.com>
	 <a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
	 <200802261911.39577.chris2553@googlemail.com>
	 <20080226194838.GD3013@tuxdriver.com>
	 <c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com>
	 <20080226223814.4ef2b435@morte>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/2008, Stefano Brivio <stefano.brivio@polimi.it> wrote:
> On Tue, 26 Feb 2008 21:13:48 +0000
>  "Chris Clayton" <chris2553@googlemail.com> wrote:
>
>  > And I will help in any way I can, providing diagnostics and trying patches.
>
>
> Please, could you mount debugfs and provide me with a dump of this file:
>  /debug/ieee80211/phy*/stations/*/rc_pid_events
>

Here's a dump that I started, then began pinging my gateway in another
terminal until the network failed and then stopped the dump with ^C a
few seconds later. Hope it helps.

[chris:~]$ cat /debug/ieee80211/phy0/stations/00\:60\:b3\:77\:73\:1a/rc_pid_events
3 131904 tx_status 0 0
4 131904 pf_sample 0 3584 840 0
5 134212 tx_rate 0 10
6 134212 tx_status 0 0
7 134212 pf_sample 0 3584 1183 0
8 134212 tx_rate 0 10
9 134213 tx_status 0 1
10 134462 tx_rate 0 10
11 134462 tx_status 0 0
12 134462 pf_sample 8448 -4864 427 8448
13 134713 tx_rate 0 10
14 134713 tx_status 0 0
15 134713 pf_sample 0 3584 821 -8448
16 134713 rate_change 0 10
17 134964 tx_rate 0 10
18 134964 tx_status 0 0
19 134964 pf_sample 0 3584 1167 0
20 135215 tx_rate 0 10
21 135215 tx_status 0 0
22 135215 pf_sample 0 3584 1469 0
23 135215 rate_change 1 20
24 135466 tx_rate 1 20
25 135466 tx_status 0 0
26 135466 pf_sample 0 3584 1733 0
27 135466 rate_change 2 55
28 135717 tx_rate 2 55
29 135717 tx_status 0 0
30 135717 pf_sample 0 3584 1965 0
31 135717 rate_change 129 -541505508
32 135968 tx_rate 11 540
33 136219 tx_rate 11 540
34 136470 tx_rate 11 540
35 136721 tx_rate 11 540
36 136972 tx_rate 11 540
37 137223 tx_rate 11 540
38 137474 tx_rate 11 540
39 137725 tx_rate 11 540
40 137976 tx_rate 11 540
41 138227 tx_rate 11 540
^C


Chris

>  Thank you.
>
>
>  --
>  Ciao
>
> Stefano
>

-- 
Beauty is in the eye of the beerholder.
