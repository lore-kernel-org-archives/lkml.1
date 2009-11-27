Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZK0Tqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZK0Tqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 14:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZK0Tqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 14:46:51 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:5062 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751732AbZK0Tqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 14:46:50 -0500
Message-ID: <4B102CE5.1050901@ru.mvista.com>
Date: Fri, 27 Nov 2009 22:47:49 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_hpt3x2n: fix overclocked MWDMA0 timing
References: <200911271956.55939.bzolnier@gmail.com> <4B102B83.1080102@ru.mvista.com>
In-Reply-To: <4B102B83.1080102@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> ---
>> Sergei, XFER_UDMA_5 timing also looks suspicious,
>> please take a look when you have a minute, thanks.

>    Yeah, but it's the same as XFER_UDMA_4, so actually underclocked... 
> However, it matches what the HPT371N datasheet and the vendor drivers 
> have. The 'hpt366' driver uses more speedy mode, with 22.5 ns cycle. ;-)

    I have just verified: this driver has always used this timing 
historically, at least for HPT372+ chips.

MBR, Sergei

