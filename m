Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZLCU4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZLCU4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZLCU4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:56:49 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:47070 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZLCU4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:56:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Alp7wrRfokTu2Hdw1vML7yEC9TGQRVcL2xHa6KGA75tAB/kAyhEnvgpxAYC11bEWgM
         9v2BloFOBtU6KUQh+aohAl+4DDsK80rfB0FTleYWsCydhxYwWlSx2hAW3NNR55Pw8205
         mmwnwQ6i1dB0P1eiOg/ZLhHPEr2O5Y44EI9N4=
Message-ID: <4B182615.8030104@garzik.org>
Date: Thu, 03 Dec 2009 15:56:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_hpt3x2n: fix overclocked MWDMA0 timing
References: <200911271956.55939.bzolnier@gmail.com> <4B102B83.1080102@ru.mvista.com> <4B102CE5.1050901@ru.mvista.com>
In-Reply-To: <4B102CE5.1050901@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2009 02:47 PM, Sergei Shtylyov wrote:
> Hello, I wrote:
>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> ---
>>> Sergei, XFER_UDMA_5 timing also looks suspicious,
>>> please take a look when you have a minute, thanks.
>
>> Yeah, but it's the same as XFER_UDMA_4, so actually underclocked...
>> However, it matches what the HPT371N datasheet and the vendor drivers
>> have. The 'hpt366' driver uses more speedy mode, with 22.5 ns cycle. ;-)
>
> I have just verified: this driver has always used this timing
> historically, at least for HPT372+ chips.

Could you clarify which "this timing" you are referring to?  :)  I never 
saw an Acked-by on this one.

	Jeff




