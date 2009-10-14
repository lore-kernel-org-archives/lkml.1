Return-Path: <linux-kernel-owner+w=401wt.eu-S1760719AbZJNAlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbZJNAlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZJNAlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:41:02 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:7563 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZJNAlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tnEn0NkwKfJCh/Qu2ZM3x70Ymglgw1yfrKXx3u1kqw803/7nobinNbKUAWq1VFD+a3
         P8rtj1kqja3MUzOMMqRVGZtBfsbPDFlIEcuKDCuuOOkeMWAzli4Qa1222IRjDAA65aZx
         6wEJqeE0EAaW+YT+9qRJiVXlUGiTXd3PdPs5k=
Message-ID: <4AD51C4E.1090204@gmail.com>
Date: Tue, 13 Oct 2009 18:33:18 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: nut-upsuser@lists.alioth.debian.org, linux-kernel@vger.kernel.org
Subject: Re: USB/UPS connectivity issue on Intel DP55KG Motherboard
References: <alpine.DEB.2.00.0910131749190.5034@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0910131749190.5034@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 03:55 PM, Justin Piszcz wrote:
> Hello,
>
> I use the following in my ups.conf:
>
> # USB:
> [apc]
> driver = usbhid-ups
> port = auto
> desc = "APC 1500VA"
> pollfreq = 5
>
> On my new motherboard (an Intel DP55KG), every once and awhile I get this:
>
> Broadcast Message from nut@box.com
> (somewhere) at 17:48 ...
>
> Communications with UPS apc@localhost lost
>
>
> Broadcast Message from nut@box.com
> (somewhere) at 17:48 ...
>
> Communications with UPS apc@localhost established
>
> On my previous motherboard (a DG965WH), the exact same configuration was
> used
> and I never had this issue.
>
> Any hints?
>
> Should I increase the pollfreq to say 30 seconds?
>
> Would this 'workaround' the problem?
>
> Is this a known bug on this chipset?

Anything unusual showing up in dmesg?
