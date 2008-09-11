Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYIKKEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYIKKEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYIKKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:03:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:12370 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbYIKKDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=sEa28PDzaUM4XBrvwjlu2F4ZIhEqK5kRX9gV037tvSIXzuhs3JjoPBuGXFy1G08SrO
         nZky4Z4n6LnWOIHGMC/7810ZqM3ZioYDWqJWJdhnaDZVWol5WObBq09NBodfcHbAIM5l
         vWbJyxDoMOW3wsIp5X+aBcVOWG60GEkuuKp9k=
Message-ID: <ea8d860a0809110303g68d7cf2fs7affd9103abc9b24@mail.gmail.com>
Date: Thu, 11 Sep 2008 12:03:52 +0200
From: "Marcin Obara" <marcin_obara@users.sourceforge.net>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: tpm-correct-tpm-timeouts-to-jiffies-conversion.patch -> 2.6.27
Cc: "Jiri Slaby" <jirislaby@gmail.com>, tpm@selhorst.net, kjhall@us.ibm.com,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com,
       debora@linux.vnet.ibm.com
In-Reply-To: <20080910152258.762e3714.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C84619.8030303@gmail.com>
	 <20080910152258.762e3714.akpm@linux-foundation.org>
X-Google-Sender-Auth: bf653ce494969bce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/11 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 11 Sep 2008 00:11:37 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
>
>> Hi,
>>
>> is it possible to push
>> tpm-correct-tpm-timeouts-to-jiffies-conversion.patch
>> (the patch header follows) into 2.6.27, please?
>
> Sure.
>
>> From: Marcin Obara <marcin_obara@users.sourceforge.net>
>>
>> This patch fixes timeouts conversion to jiffies, by replacing
>> msecs_to_jiffies() calls with usecs_to_jiffies().  According to TCG TPM
>> Specification Version 1.2 Revision 103 (pages 166, 167) TPM timeouts and
>> durations are returned in microseconds (usec) not in miliseconds (msec).
>>
>> Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
>> Cc: Marcel Selhorst <tpm@selhorst.net>
>> Cc: Kylene Jo Hall <kjhall@us.ibm.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> Why?  I wasn't aware that this fixed anything which anyone had observed
> (pokes tongue out at the changelog).
>

This fixes i.e.: long hang while loading TPM driver, if TPM chip
starts in "Idle" state instead of "Ready" state.
Without this patch - 'modprobe' may hang for 30 seconds or more.
Please, push this patch into 2.6.27.

Marcin
