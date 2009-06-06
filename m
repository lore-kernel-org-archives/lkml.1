Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZFFP6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZFFP6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 11:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZFFP6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 11:58:42 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36421 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZFFP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 11:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xF/s7y5X1tGZlEi2Dnfw6+jOzqL+luKJsRMDDVJhTTpNWOG3JZbkNYk0ovadgJc8gB
         iuqx05rhCdOCpuW2odRo6+HwAqJiAIlrrQN1STw/I6+29F4RswblaLL0L/LguK4EOO3K
         +xA1xbvb8ktwALNAdvfDx3hs0tGN7V57aLj5E=
Message-ID: <4A2A9230.5080305@gmail.com>
Date: Sat, 06 Jun 2009 17:58:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.2 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sound] mpd loops on current -next
References: <4A2A8F6A.80705@gmail.com> <alpine.LNX.2.00.0906061752040.4067@eeebox2.perex-int.cz>
In-Reply-To: <alpine.LNX.2.00.0906061752040.4067@eeebox2.perex-int.cz>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2009 05:52 PM, Jaroslav Kysela wrote:
> On Sat, 6 Jun 2009, Jiri Slaby wrote:
>> I found a regression in current -next caused by
>> c44941e05900fe85f6091456f9e313b446a97ae9
>> (PCM midlevel: Do not update hw_ptr_jiffies when hw_ptr is not changed)
> 
> Oops. It seems like typo. Could you try this patch, please?

Yup, looks like that did the job.

Thanks.
