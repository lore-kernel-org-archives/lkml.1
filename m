Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbYHNMQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbYHNMQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbYHNMP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:15:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:55117 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234AbYHNMP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nzLMubvD+EZGKnds5Op2N1juAK6o6Qi2n4Db5II4a3+odviAp6MS8N1kTThZt+I+kU
         KQuUSKw3gYoGZ2yA0vqHM5mByqo5Xh6uVHkXSwio7HR1L/BTpGKDPQi6bk84WTKx+rQX
         4vO+ceUDzqUQE7KjXfhgGjT2FBGWXtJWsxsv8=
Message-ID: <1ba2fa240808140515r92a3ec7i90ea6c03e2adb7ee@mail.gmail.com>
Date: Thu, 14 Aug 2008 15:15:56 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Will Simoneau" <simoneau@ele.uri.edu>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net, "Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <20080814062604.GA16234@ele.uri.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1ba2fa240808131411o638311f1m2e2daa6ef62057b1@mail.gmail.com>
	 <20080814062604.GA16234@ele.uri.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 9:26 AM, Will Simoneau <simoneau@ele.uri.edu> wrote:
> On 00:11 Thu 14 Aug     , Tomas Winkler wrote:
>> Intel would like to announce Linux support  for Wifi Link 5000 and
>> 5100 Series Adapters under iwlwifi driver (iwlagn.ko)
>>
> ...
>> The best known working driver can be located in iwl500 branch of
>> iwlwifi-2.6.git
>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git iwl5000
>
> This is great news to me - my new Sager laptop has a 5300 card. However,
> it doesn't seem to work:
>
> iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> iwlagn: Copyright(c) 2003-2008 Intel Corporation
> iwlagn 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwlagn 0000:07:00.0: setting latency timer to 64
> iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
> iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
> phy7: Selected rate control algorithm 'iwl-agn-rs'
> iwlagn 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> firmware: requesting iwlwifi-5000-1.ucode
> iwlagn 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwlagn: START_ALIVE timeout after 4000ms.
>

Yes, this was already reported, but I was not able to reproduce it so
far on my machines. I'm still trying to locate
a machine that behaves same.

> I have the microcode in /lib/firmware, and the kernel/driver source is
> the latest from iwlwifi-2.6.git. What else should I provide for
> debugging?
>

is this iwl5000 branch ?

Thanks
Tomas
