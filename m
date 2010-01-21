Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921Ab0AUEJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0AUEJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348Ab0AUEJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:09:12 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39636 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab0AUEJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:09:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qAIgJXOSdlzuZY3sVJKV5NKpZq76s6jZa0gCkJKOQ3QOzLp4eZerZfw9+Z4IwxYSuu
         IqG/zEDmzGaXAnDePjTes2ABrWULYBYeyCqcyPai1sqxweA0DOFkPuSJtabIDxk+eKEk
         gDdADIe+r/22uOCK8sIjSwgJaNbM00Vvn4+os=
Message-ID: <4B57D365.3040201@garzik.org>
Date: Wed, 20 Jan 2010 23:09:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/64] pata_atiixp: remove superfluous wrapper function
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171427.14623.34958.sendpatchset@localhost> <4B57D2E4.30203@garzik.org>
In-Reply-To: <4B57D2E4.30203@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 11:07 PM, Jeff Garzik wrote:
> On 01/18/2010 12:14 PM, Bartlomiej Zolnierkiewicz wrote:
>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>> Subject: [PATCH] pata_atiixp: remove superfluous wrapper function
>>
>> Fix documentation for ->set_[pio,dma]mode methods while at it.
>>
>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>> ---
>> drivers/ata/pata_atiixp.c | 29 +++++++----------------------
>> 1 file changed, 7 insertions(+), 22 deletions(-)
>
> applied

undone...  it broke the build, presumably because it requires something 
in your tree that's not in libata-dev.git


