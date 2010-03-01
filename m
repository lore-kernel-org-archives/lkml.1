Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab0CAUSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:18:35 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:34468 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0CAUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:18:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FUVPXsHTcdN+0PxRNXfTECOA3cvGu/Reln2A3G3GURvV119ueNZbmdTkLNYvYSs+Pf
         zsWISr21VFL3Qm9HMMqDI2uqNXnZVsAE/I94c8LNo4/d9DqiSTRw7yDV8hHd9WTbypCf
         hF4woSrNYfrhUKlejaAoDNP+6qzKt1qKUFUCI=
Message-ID: <4B8C2114.1030806@pobox.com>
Date: Mon, 01 Mar 2010 15:18:28 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Roman Fietze <roman.fietze@telemotive.de>, linuxppc-dev@lists.ozlabs.org,
       linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pata_mpc52xx: optimizing code size by change of ATA 
 timing data types
References: <200912161429.14968.roman.fietze@telemotive.de> <fa686aa41002161141v20a06768nbdcdb094293bb5b2@mail.gmail.com>
In-Reply-To: <fa686aa41002161141v20a06768nbdcdb094293bb5b2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 02:41 PM, Grant Likely wrote:
> [cc'd linux-kernel, linux-ide and Jeff Garzik]
>
> Hi Roman.
>
> you should use ./scripts/get_maintainer.pl to make sure you're cc'ing
> the right people when posting patches.  You should repost so that Jeff
> has a copy of the patch to pick up (and add my acked-by when you do).
>
> On Wed, Dec 16, 2009 at 6:29 AM, Roman Fietze
> <roman.fietze@telemotive.de>  wrote:
>> Hello Everybody,
>>
>> A totally simple patch that reduces the text size as of the
>> ppc_6xx-size command of pata_mpc52xx by more than 10%, by reducing the
>> rodata size from 0x4a4 to 0x17e bytes. This is simply done by changing
>> the data types of the ATA timing constants.
>
> Acked-by: Grant Likely<grant.likely@secretlab>

I have the ACK, but never saw the requested repost...  req that, please?

