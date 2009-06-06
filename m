Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZFFQ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZFFQ4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 12:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZFFQ4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 12:56:08 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36254 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZFFQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 12:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YB1es49JyuR6lTPkFj740uTga1A7GkjxivTX6gyePqojnnLOsYapH8OZhA/Na7qDAt
         gTi7DheGmeCtS1QRZZL8W9MEAkhL28DdmteQE96AwU1bImIkso3cdveD6AAyThJ8SaXm
         +zj7NQd6Bzyc4HRHGNUQel7jl0ANbE+SrZAWo=
Message-ID: <4A2A9FA4.8000007@gmail.com>
Date: Sat, 06 Jun 2009 18:56:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sound] mpd loops on current -next
References: <4A2A8F6A.80705@gmail.com>	<alpine.LNX.2.00.0906061752040.4067@eeebox2.perex-int.cz> <s5heitx8gjs.wl%tiwai@suse.de>
In-Reply-To: <s5heitx8gjs.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2009 06:37 PM, Takashi Iwai wrote:
>>> I found a regression in current -next caused by
>>> c44941e05900fe85f6091456f9e313b446a97ae9
>>> (PCM midlevel: Do not update hw_ptr_jiffies when hw_ptr is not changed)
>>
>> Oops. It seems like typo. Could you try this patch, please?
> 
> Ah, that's the cause of the bug with PA on the recent driver.
> I didn't experience the problem because I myself don't use PA :)

FWIW me neither...
