Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbXIGXtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbXIGXtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXIGXsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:48:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57873 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbXIGXst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:48:49 -0400
Message-ID: <46E1E35F.1010907@garzik.org>
Date: Fri, 07 Sep 2007 19:48:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Gaston, Jason D" <jason.d.gaston@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ata_piix: IDE mode SATA patch for
 Intel Tolapai
References: <200708302136.57215.jason.d.gaston@intel.com> <46D7C856.5070901@garzik.org> <39B20DF628532344BC7A2692CB6AEE0701BCF3BF@orsmsx420.amr.corp.intel.com>
In-Reply-To: <39B20DF628532344BC7A2692CB6AEE0701BCF3BF@orsmsx420.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gaston, Jason D wrote:
>> -----Original Message-----
>> From: Jeff Garzik [mailto:jeff@garzik.org]
>> Sent: Friday, August 31, 2007 12:51 AM
>> To: Gaston, Jason D
>> Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org;
>> htejun@gmail.com
>> Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ata_piix: IDE mode SATA patch
> for
>> Intel Tolapai
>>
>> Jason Gaston wrote:
>>> Resend trying to remove 8-bit characters in the email.
>>>
>>> This patch adds the Intel Tolapai IDE mode SATA controller DID's.
>>>
>>> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
>> applied
> 
> Jeff,
> 
> I just noticed that the following section came through as spaces instead
> of tabs.  Do I need to resend a corrected version?
> 
> +static const struct piix_map_db tolapai_map_db = {
> +        .mask = 0x3,
> +        .port_enable = 0x3,
> +        .map = {
> +                /* PM   PS   SM   SS       MAP */
> +                {  P0,  NA,  P1,  NA }, /* 00b */
> +                {  RV,  RV,  RV,  RV }, /* 01b */
> +                {  RV,  RV,  RV,  RV }, /* 10b */
> +                {  RV,  RV,  RV,  RV },
> +        },
> +};

that's always nice, yes :)

even better would be to run a script through #upstream, accomplishing 
the same thing but for many drivers ;-)


