Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYGQL54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYGQL54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYGQL5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:57:46 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:37627 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYGQL5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:57:45 -0400
Message-ID: <487F33A7.4040809@diamondcut.com.br>
Date: Thu, 17 Jul 2008 08:57:27 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Robert M. Albrecht" <romal@gmx.de>
CC: linux-acpi@vger.kernel.org, pavel@suse.cz, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: Toshiba - Documentation for Linux Developers
References: <4855971D.90004@diamondcut.com.br> <20080616221443.GA760@kroah.com>	 <b170af450807130654m2f800b10ybcba4b2c5c7cf329@mail.gmail.com>	 <487A1534.3000307@diamondcut.com.br>	 <b170af450807150017u248d4255i3800c10cb11df319@mail.gmail.com>	 <487C865C.5060303@diamondcut.com.br> <b170af450807150446l555e9bbfx3f388d3ebe9cb11f@mail.gmail.com> <487E5130.9040208@gmx.de>
In-Reply-To: <487E5130.9040208@gmx.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ed Greg KH]

Only to remember: Toshiba website to Linux Developers is:
<http://linux.toshiba-dme.co.jp/linux/eng/develop.htm>

Best regards,
Renato S. Yamane


Robert M. Albrecht wrote:
> Hi,
> 
> both Toshiba types (original and compal-oem machines) are basically
> unsupported for Linux.
> 
> The omnibook-module for compal-systems was maintained outside the kernel
> and stalled for some time now.
> 
> The toshiba_acpi included in the kernel is outdated (there is a newer
> release, that fixes some bugs). Toshiba_acpi does only work on 32 bit
> systems, it breaks on 64 bit systems.
> 
> If anyone is interested in some hacking I can provide shell-access to
> both types of machines.
> 
> For some Tecra machines, Toshiba has provided some Vista-compatible
> BIOSes, they seem to enhance acpi-stuff for Linux too. So you might look
> for a bios-update.
> 
> cu romal
> 
> www.romal.de
> blog.romal.de
> 
> Rafał Miłecki schrieb:
>> 2008/7/15, Renato S. Yamane <yamane@diamondcut.com.br>:
>>> Rafał Miłecki wrote:
>>>  > The newest version is packed for openSUSE fortunately. But it doesn't
>>>  > for my notebook
>>>
>>> Try compile SVN version as commented in my last e-mail
>>
>> OK, I tried version from SVN. Nothing changed :|
>>
>>
>>>  > dmesg is:
>>>  > omnibook: Driver version 2.20070211-trunk.
>>>  > omnibook: Unknown model.
>>>
>>>
>>> Try force recognize with ectype parameter.
>>>  #modprobe omnibook ectype=x
>>
>> Sure, I tried every ectype between 1 and 15 before (omnibook from
>> package) and now (version from SVN) again. I checked two files (when
>> existed): lcd and temperature. Temperature (if file existed for forced
>> ectype) was always 0 and lcd always had some random values. Inserting
>> other values (1, 7) didn't change anything.
