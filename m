Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZEHF6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZEHF6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZEHF6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:58:10 -0400
Received: from 76-10-159-13.dsl.teksavvy.com ([76.10.159.13]:47253 "EHLO
	qhoops.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbZEHF6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:58:08 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 01:58:08 EDT
Message-ID: <6818156.7441241761835737.JavaMail.james@prod3.pk.lan>
MIME-Version: 1.0
X-UserIsAuth: true
Date: Sat, 09 May 2009 01:50:12 -0400
From: Jason Daly <jason2@primarykey.ca>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Karl Hiramoto <karl@hiramoto.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] New kernel recommendations for ath9k
References: <43e72e890905070104u59eebcceu18718a733e388cc9@mail.gmail.com> 	<4A02B1CA.3060708@hiramoto.org> <43e72e890905071020v26857c52p3abea96be04ef1d9@mail.gmail.com>
In-Reply-To: <43e72e890905071020v26857c52p3abea96be04ef1d9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-P3Scan: v2.3.2 by Jack S. Lai. No outbound virus detected.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the kernel info.

How do you configure hostapd to work in N mode with ath9k?  Currently 
the hw_mode parameter found in hostapd.conf does not accept anything 
greater than g.

Thanks
-JD

Luis R. Rodriguez wrote:
> On Thu, May 7, 2009 at 3:02 AM, Karl Hiramoto <karl@hiramoto.org> wrote:
>> Luis R. Rodriguez wrote:
>>> For those not subscribed to the ath9k wiki on wireless.kernel.org [1]
>>> (which we recommend you do if you're a user) here's a quick note to
>>> let you know our latest kernel recommendations for using ath9k:
>>>
>>>  *  >= 2.6.27.22
>>>  *  >= 2.6.28.10
>>>  *  2.6.29
>>>
>>> If you want 802.11n support or AP support you'll want at least 2.6.29.
>>> If you happen to have one of our new 1x1 AR9285 devices (all AR9285
>>> devices are 1x1) then you'll need at least 2.6.29. If you want to
>>> start using ath9k on APs with AHB you will need at least 2.6.30 (still
>>> in RC series).
>>>
>>> As usual if you happen to be stuck on older kernels for one reason or
>>> another you can always use compat-wireless [2] and if that happens to
>>> be a little too bleeding edge we have now compat-wireless releases for
>>> stable kernel releases, starting as of the 2.6.30-rc series [3].
>>>
>>>  Luis
>>>
>>> [1] http://wireless.kernel.org/en/users/Drivers/ath9k
>>> [2] http://wireless.kernel.org/en/users/Download
>>> [3] http://wireless.kernel.org/en/users/Download/stable
>>>
>> Thanks for the update.  If i want to use multiple AP's with Ath9k it it
>> still best to use wireless-testing?  Is multiple AP support in 2.6.30-rc
>> series net-next or wireless-next?
> 
> Yeah wireless-testing is best for that. I should also mention that if
> you want to use AP mode you want to be at least on 2.6.29 (your own
> kernel, not the compat-wireless one) if you care about Power Save
> buffering on the AP as otherwise even if you use a compat-wireless
> with code from > 2.6.29 those frames will be dropped. IIRC its due to
> the way we use skb->cb for this and there not being a clean way to
> backport this (so we just drop them).
> 
>   Luis
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel


