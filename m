Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZGUOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZGUOY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 10:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZGUOY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 10:24:26 -0400
Received: from smtp.nokia.com ([192.100.105.134]:57753 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbZGUOYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 10:24:25 -0400
Message-ID: <4A65CF81.9070008@gmail.com>
Date: Tue, 21 Jul 2009 17:24:01 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Felipe Balbi <me@felipebalbi.com>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/4] staging: cpc-usb: convert comment style in cpc.h
References: <1248180746-18140-1-git-send-email-me@felipebalbi.com> <1248180746-18140-2-git-send-email-me@felipebalbi.com>
In-Reply-To: <1248180746-18140-2-git-send-email-me@felipebalbi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Jul 2009 14:24:18.0301 (UTC) FILETIME=[EEA3C2D0:01CA0A0E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 03:52 PM, Felipe Balbi wrote:
> Signed-off-by: Felipe Balbi<me@felipebalbi.com>
> ---
>   drivers/staging/cpc-usb/cpc.h |  504 +++++++++++++++++++----------------------
>   1 files changed, 233 insertions(+), 271 deletions(-)
>
> diff --git a/drivers/staging/cpc-usb/cpc.h b/drivers/staging/cpc-usb/cpc.h
> index ed8cb34..774ea22 100644
> --- a/drivers/staging/cpc-usb/cpc.h
> +++ b/drivers/staging/cpc-usb/cpc.h
> @@ -10,243 +10,216 @@
>   #ifndef CPC_HEADER
>   #define CPC_HEADER
>
> -// the maximum length of the union members within a CPC_MSG
> -// this value can be defined by the customer, but has to be
> -//>= 64 bytes
> -// however, if not defined before, we set a length of 64 byte
> +/* the maximum length of the union members within a CPC_MSG
> + * this value can be defined by the customer, but has to be
> + *>= 64 bytes
> + * however, if not defined before, we set a length of 64 byte
> + */

If you decided to clean this up, then how about using better
commenting style documented in Documentation/CodingStyle?

Namely, Use
/*
  * blah
  */

style.

Also, how about making sentences start from a capital letter,
and re-format the whole comment better?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
