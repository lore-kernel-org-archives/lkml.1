Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbXIMPKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbXIMPKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXIMPKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:10:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbXIMPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:10:44 -0400
Message-ID: <46E952D8.2000203@zytor.com>
Date: Thu, 13 Sep 2007 08:10:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Bill Nottingham <notting@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
References: <20070831201820.GF31970@nostromo.devel.redhat.com> <Pine.LNX.4.64.0709071348090.25942@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709071348090.25942@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 31 2007 16:18, Bill Nottingham wrote:
>> As of now, the kernel defaults to non-unicode and XLATE for the keyboard.
>> We've been changing this in Fedora, but that requires patching the defaults
>> in the kernel.
>>
>> The attached introduces CONFIG_VT_UNICODE, which sets the console in unicode
>> mode by default on boot, including both the virtual terminal and the keyboard
>> driver.
> 
> I would prefer to:
>  - make default_utf=1 in the source
>  - add "default_utf8 ? VC_UNICODE : VC_XLATE" to the keyboard code
>    as your patch does
>  - and do away with the new CONFIG_ option, since, surprise, surprise,
>    you can change it at runtime, so there is no need to do it
>    at compile-time too.
> 

I concur.

	-hpa
