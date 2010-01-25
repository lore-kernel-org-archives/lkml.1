Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833Ab0AYJNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab0AYJNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 04:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776Ab0AYJNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 04:13:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:41999 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0AYJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 04:13:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SlTPjJa53S5TUoC/l8vyqWqe2MH1N2ErNeesxif5rg3AzbV+rqGHj3gHxH/SDc8AHj
         tw6UMagRWQUCrzI+wKAzCnxX/lnbyInmZ2etMx9dxWkhhsqfWuyn/KEXoMEbi7k44SaR
         8mMu2/w2O5SAPwBxzduhuqkDNTXQ4KSNVe6rw=
Message-ID: <4B5D6098.7010700@gmail.com>
Date: Mon, 25 Jan 2010 10:12:56 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi>
In-Reply-To: <4B5CDB53.6030009@iki.fi>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 12:44 AM, Antti Palosaari wrote:
> When I now test this patch with debugs enabled I don't see
> .probe and .disconnect be called for this HID interface (interface 1) at
> all and thus checks not needed.

What happens if you disable the HID layer? Or at least if you add an
ignore quirk for the device in usbhid?

I forbid usbhid to attach to the device, as the remote kills X with HID
driver. With dvb-usb-remote it works just fine (with remote=2 for af9015
or the 4 patches I've sent).

-- 
js
