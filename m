Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZK3H0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZK3H0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZK3H0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:26:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51025 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbZK3H0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:26:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B13738E.2000202@jp.fujitsu.com>
Date: Mon, 30 Nov 2009 16:26:06 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/9] pci: update pci bridge resource to get more big range
 for devices under it - v13
References: <4ADEB601.8020200@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B10D286.4020607@kernel .org> <4B136FEE.7060305@jp.fujitsu.com> <4B1370D8.3070600@kernel.org>
In-Reply-To: <4B1370D8.3070600@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Kenji Kaneshige wrote:
>> My system doesn't boot (hangup) with the following error messages
>> from Fusion MPT SAS driver. Those are different from the one
>> captured with the previous version of your patches.
>>
>>
>> Fusion MPT SAS Host driver 3.04.12
>> mptsas 0000:09:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>> mptbase: ioc0: Initiating bringup
>> mptbase: ioc0: WARNING - Unexpected doorbell active!
>> mptbase: ioc0: ERROR - Failed to come READY after reset! IocState=f0000000
>> mptbase: ioc0: WARNING - ResetHistory bit failed to clear!
>> mptbase: ioc0: ERROR - Diagnostic reset FAILED! (ffffffffh)
>> mptbase: ioc0: WARNING - NOT READY WARNING!
>> mptbase: ioc0: ERROR - didn't initialize properly! (-1)
>> mptsas: probe of 0000:09:00.0 failed with error -1
>> mptsas 0000:0a:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
>> mptbase: ioc1: Initiating bringup
>> mptbase: ioc1: WARNING - Unexpected doorbell active!
>> mptbase: ioc1: ERROR - Failed to come READY after reset! IocState=f0000000
>> mptbase: ioc1: WARNING - ResetHistory bit failed to clear!
>> mptbase: ioc1: ERROR - Diagnostic reset FAILED! (ffffffffh)
>> mptbase: ioc1: WARNING - NOT READY WARNING!
>> mptbase: ioc1: ERROR - didn't initialize properly! (-1)
>> mptsas: probe of 0000:0a:00.0 failed with error -1
>>
>>
>> I'll send the whole boot log privately.
> 
> thanks, at the same time please try "debug pci=try=1"
> 

I confirmed system boot up without errors by "pci=try=1".
I'll capture the bootlog with "debug" option and send it
to you soon.

Thanks,
Kenji Kaneshige


