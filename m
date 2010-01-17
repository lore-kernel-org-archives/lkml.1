Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540Ab0AQT3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0AQT3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 14:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519Ab0AQT3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 14:29:12 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34128 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab0AQT3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 14:29:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Zs/0HTo2ln3hp7tdsMP5Sj0eFZdnIKzr3sjjxbT/3ihJ/MVJT9aZno1Jh194K9xJHU
         k8Vlug4l0UfAuLn9KzESN7hwmFAd1P4+BEX1imZHwK++p4uYze93E5rqgHn7qE8mPwK+
         bcdA/EUXx9gx+HqB2DR+q8Y9P3Csm9G0Dyn9c=
Message-ID: <4B536502.20102@gmail.com>
Date: Sun, 17 Jan 2010 13:29:06 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, yong.y.wang@linux.intel.com,
       linux-kernel@vger.kernel.org, huaxu.wan@intel.com,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (coretemp) Fix TjMax for Atom   
 N450/D410/D510 CPUs
References: <20091224073102.GA23058@ywang-moblin2.bj.intel.com>	<20100106160817.72313551@hyperion.delvare>	<20100110200621.564a6682@hyperion.delvare>	<20100111062024.GA20804@ywang-moblin2.bj.intel.com>	<SNT125-W147C55AB6EB65D41CAAFFFC3680@phx.gbl> <20100117161518.4912be7c@hyperion.delvare>
In-Reply-To: <20100117161518.4912be7c@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2010 09:15 AM, Jean Delvare wrote:
> On Fri, 15 Jan 2010 18:02:27 -0800, Yuhong Bao wrote:
>>
>>> No matter what chipset or gfx you use with the new Atom chip, the
>>> integrated memory controller (IMC) will always be used. This patch
>>> checks the presence of that IMC. Hope this clarifies.
>> To be more precise, Pine Trail Atoms integrate the entire northbridge, including the integrated graphics and the memory controller into the CPU, and there is a DMI connection to the southbridge, which is the Intel NM10, that is NOT integrated.
>
> What prevents another vendor from selling a compatible south bridge
> then?

Nothing (other than licensing for the DMI bus, see NVIDIA and the 
problems this creates for their ION chipset). I'm assuming this patch is 
checking for the host bridge device though, that is integrated into the 
CPU and would always be present.

>
> I start believing that we'd rather identify these Atom models using
> CPUID rather than a PCI device.
>

