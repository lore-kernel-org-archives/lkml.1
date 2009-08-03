Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbZHCXAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbZHCXAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 19:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932243AbZHCXAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 19:00:43 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46263 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbZHCXAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 19:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FX5km1R0IZP8jB7Qlwt0mLZTGe3dhxMtpKuvKJioolJfM7ugZcRuWRX6PvvBGD1jZX
         Tvyz7JMr/MlH02lCwQrEGagO1gxkB5w1+oAlF2LAr4UyxW6Rnpc+5SSLM9yT8YYIlx9y
         NReD9il5HgeVCvicTbJy5JDJyGymqPh+fejrQ=
Message-ID: <4A776C10.50409@gmail.com>
Date: Tue, 04 Aug 2009 01:00:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: martyn.welch@gefanuc.com
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [patch 3/5] Staging: vme: add Universe I/II bridge driver
References: <20090803205657.964064732@mini.kroah.org> <20090803210118.GD28430@kroah.com>
In-Reply-To: <20090803210118.GD28430@kroah.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 11:01 PM, Greg K-H wrote:
> +int uni_init(void)
> +{
...
> +	result =
> +	    request_irq(vmechip_irq, uni_irqhandler, IRQF_SHARED | IRQF_DISABLED,

DISABLED on SHARED is not guaranteed. You must specify one or the other.
