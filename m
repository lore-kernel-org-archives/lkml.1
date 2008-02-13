Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYBMHoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYBMHoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbYBMHor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:44:47 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:56093
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbYBMHoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:44:46 -0500
Message-ID: <47B29FB5.40205@qumranet.com>
Date: Wed, 13 Feb 2008 09:43:49 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: KVM: Export include/linux/kvm.h only if $ARCH actually supports
 KVM
References: <20080210111525.GA28522@aepfle.de>
In-Reply-To: <20080210111525.GA28522@aepfle.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
>> Currently, make headers_check barfs due to <asm/kvm.h>, which <linux/kvm.h>
>> includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export kvm.h
>> only if the arch actually supports it.
>>     
>
> This makes headers_install_all unreliable.
> linux/kvm.h will not be exported, depending on what system the libc
> headers will be generated. 

I see.  Any suggestions besides adding lots of asm-*/kvm.h?

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

