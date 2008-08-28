Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYH1H7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYH1H7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYH1H7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:59:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:16355 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYH1H7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:59:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dMjcu69D8HqSwcbfjV/0Iga56EhQ/WSvmYupFmfF5R+02WTJviBTmGYBrVF7MZtxp+
         wucm58gAOMazLRAfVAyVyZASXcGeg8JlLfPaKamMLDWg7pocWA10uQQO7HJsj5Baa13z
         cDsz6IoTdEj9RLcIe8V6rZxHmc6D31peUxP98=
Message-ID: <1ba2fa240808280059i24d2ee56rd7a3c37150e1c03c@mail.gmail.com>
Date: Thu, 28 Aug 2008 10:59:20 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: "Michael Buesch" <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Bruno Randolf" <bruno@thinktube.com>
In-Reply-To: <43e72e890808271830k6e0a9e65j790ee1e0d6d52d36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080827013009.GA15781@tuxdriver.com>
	 <1ba2fa240808271226i95a7789k481a68b09dc60164@mail.gmail.com>
	 <200808272225.10557.mb@bu3sch.de>
	 <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com>
	 <20080827233103.GE5927@tesla>
	 <1ba2fa240808271719o2a3617e7re0499670de785b2f@mail.gmail.com>
	 <43e72e890808271830k6e0a9e65j790ee1e0d6d52d36@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 4:30 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Aug 27, 2008 at 5:19 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>> This patch is marked as W/A and should have
>> probably some cleaner solution in 2.6.28
>
> OK
>
>>>> Last solution would be to remove this merging all together
>>>
>>> Absolutely not! IBSS merge is per spec, otherwise you don't really have
>>> a real IBSS.
>>
>> I'm all for following spec and we've tried really hard to make it work.
>> Anyhow I'm not sure what you call real IBSS. nobody has checked it for
>> 1.5 year this patch  is in and now is suddenly so important...
>
> I don't care about your work around, I was replying due to your insane
> comments about considering removing IBSS merge support because your
> hardware does not support it well.

Insane?!, watch your language mister I will catch you on next year OLS
:) This is definitely
not any highlighted proposal in my message

>> I would like to see if there is any  HW under mac80211 that actually
>> work with this.
>
> Atheros hardware supports IBSS merge, please consider a proper work
> around instead for hardware which does not support this.

So how do set TSF from the beacon, I'm asking because there is
currently no interface from mac80211 to driver do that.
Thanks
Tomas
