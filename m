Return-Path: <linux-kernel-owner+w=401wt.eu-S932355AbZFINOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbZFINOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbZFINOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:14:42 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:36786 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbZFINOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:14:40 -0400
X-Auth-Info: 0nRITSiPUPM1NY5Vq5EjiLaDTiofEDdjDFD0QmiPFWM=
Message-ID: <4A2E603E.3040603@grandegger.com>
Date: Tue, 09 Jun 2009 15:14:38 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net tree build warning
References: <20090609203639.96e503fe.sfr@canb.auug.org.au>	<4A2E46A7.6020302@grandegger.com> <20090609.042625.194310688.davem@davemloft.net>
In-Reply-To: <20090609.042625.194310688.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Wolfgang Grandegger <wg@grandegger.com>
> Date: Tue, 09 Jun 2009 13:25:27 +0200
> 
>> [PATCH] can: sja1000_of_platform: fix build problems with printk format
>>
>> Variables of type size_t should be printed with the format "%zx".
>>
>> Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
> 
> It's not a "size_t", it's a "resource_size_t" which can be
> "unsigned long long" on some platforms.

Right, but I assume that the %zx handles that type properly as well.
Should I send a patch with a corrected patch description?

Wolfgang.

