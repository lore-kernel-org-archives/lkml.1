Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbZDAWqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbZDAWqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZDAWqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:46:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:36725 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZDAWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aIePmnPhef2z5rFBH8sDS5DJU4TeqfsakJsGjHP1NCMc6xuXRMkIBpkAZQPJx3gZ7g
         1CoMvksnEIAAZUY+0IAJ/U4j+gp2r7vCncNOKT9R8OkVPHOjK9do8z8p7ECFEhg/aWtG
         V/iRU3FGrJZarwlCcFQnvxgxlR+ygRmaK6hOA=
MIME-Version: 1.0
In-Reply-To: <20090401155205.1f47ccc4@hskinnemoen-d830>
References: <20090401153957.6982f050@hskinnemoen-d830>
	 <1238593622-17809-1-git-send-email-hans-christian.egtvedt@atmel.com>
	 <20090401155205.1f47ccc4@hskinnemoen-d830>
Date: Wed, 1 Apr 2009 15:46:39 -0700
X-Google-Sender-Auth: dd5c702531306b6b
Message-ID: <e9c3a7c20904011546l4e540709t933b15adfbeaf4be@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] dw_dmac: add cyclic API to DW DMA driver
From: Dan Williams <dan.j.williams@intel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
       linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 6:52 AM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> Hans-Christian Egtvedt wrote:
>> This patch adds a cyclic DMA interface to the DW DMA driver. This is
>> very useful if you want to use the DMA controller in combination with a
>> sound device which uses cyclic buffers.
>>
>> Using a DMA channel for cyclic DMA will disable the possibility to use
>> it as a normal DMA engine until the user calls the cyclic free function
>> on the DMA channel. Also a cyclic DMA list can not be prepared if the
>> channel is already active.
>>
>> Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
>
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Thanks, applied.
