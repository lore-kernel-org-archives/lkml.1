Return-Path: <linux-kernel-owner+w=401wt.eu-S932726AbZLEA3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbZLEA3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932715AbZLEA3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:29:43 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:62724 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbZLEA3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:29:42 -0500
X-IronPort-AV: E=Sophos;i="4.47,344,1257138000"; 
   d="scan'208";a="9940640"
Message-ID: <4B19A92A.5030804@analog.com>
Date: Sat, 5 Dec 2009 08:28:26 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize
 program header parsing
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> <14959.1259948697@redhat.com>
In-Reply-To: <14959.1259948697@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Dec 2009 00:28:39.0696 (UTC) FILETIME=[E44B8900:01CA7541]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2009 01:44 AM, David Howells wrote:
> Mike Frysinger<vapier@gentoo.org>  wrote:
>
>> The Blackfin port has custom program header flags/addresses for
>> automatically loading regions into the dedicated on-chip SRAM.  So add a
>> hook for ports to leverage.
>
> Now that I've ACK'd this, I feel I'm going to have to NAK it.  I'm not against
> the general concept, but:
>
>> +		do_munmap(mm, *maddr, phdr->p_memsz + *disp);
>
> There needs to be a mapping covering the SRAM region for the purposes of the

Our GDB is still lack of the feature to debug applications using SRAM. 
So this part of code was not got exercised. So if we remove this line, 
can this patch got merged?

> debugger.  Do you have a chardev covering the SRAM device?  Perhaps through
> MTD?
>
Sorry, I don't know the answer to these two questions.


Jie


