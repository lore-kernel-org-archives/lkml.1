Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYHQSBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYHQSBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYHQSB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:01:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:41246 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYHQSB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AAlGGBI+dyhH69ke4oOkR9A2da1Rmfw0OPOzTGP4IRop8/d72dilCS9tOIVK1JZ5zc
         vEfNa9hsLqE4Giscki4zYzCsllrx/tCpO7F4ic/fa4UsDBSY7ulPvzeWcu6pwnH5ABrO
         0YR5IT7DjBw4EcgeIxC/XcQj8KfX48t+1TqTk=
Message-ID: <1ba2fa240808171101j8a7a94dn6be58fe1a8f46dbd@mail.gmail.com>
Date: Sun, 17 Aug 2008 21:01:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: CPU load after killing iwlagn with RF kill switch
Cc: "Mirco Tischler" <mt-ml@gmx.de>,
       "Leonid Podolny" <leonidp.lists@gmail.com>,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       IvDoorn@gmail.com
In-Reply-To: <20080817170714.GA29938@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A5EC02.4070303@gmail.com>
	 <20080817035921.4d35ae0e@mtlp.12thdimension>
	 <1ba2fa240808170004p63b76db1l1fdfb1cf1cb41636@mail.gmail.com>
	 <20080817150242.GA23926@tuxdriver.com>
	 <1ba2fa240808170920r67e11567h2da8b396b18729dd@mail.gmail.com>
	 <20080817170714.GA29938@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 8:07 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sun, Aug 17, 2008 at 07:20:54PM +0300, Tomas Winkler wrote:
>> On Sun, Aug 17, 2008 at 6:02 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > On Sun, Aug 17, 2008 at 10:04:12AM +0300, Tomas Winkler wrote:
>> >
>> >> There is gap in current rfkill implementation that we didn't close
>> >> yet.  There were also few patches that were not signed by Intel and
>> >> are apparently wrong.
>> >
>> > Can you be more specific?  Do you know which patches are wrong (even
>> > if you don't know how to fix them)?
>> >
>>
>> 80fcc9e28cf3a209fbfb39a7bbddc313c59c7424
>> This one  is wrong and there are more then are not acked even though
>> they cause no problem. In general I would prefer that patches will be
>> acked by Yi or me.
>
> And in general, they are.  In general I would prefer if you would
> work upstream instead of working in iwlwifi-2.6 and periodically
> dumping a dozen or more patches on me all at once.  C'est la vie...

We cannot because no OSV or OEM ships latest kernel and mac80211 is
periodically broken.  There is a reason why compat-wireless was
brought to life. The  innovation to stabilization and testing ratio is
not good. This is of course more complex than that and I didn't find
the golden way yet.

>> I will try to rebase our rfkill fixes ASAP from iwlwifi-2.6. iwl5000 branch.
>
> Thanks!
>
> John
> --
> John W. Linville
> linville@tuxdriver.com
>
