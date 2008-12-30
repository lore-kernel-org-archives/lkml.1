Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYL3TIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYL3TIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 14:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYL3TIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 14:08:31 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:44281 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYL3TIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 14:08:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=k+9ShwhJOfKciOTENcCYLrRPFgYrevdSERSibfmTu1FCi/gSo/AVJa8aRC4w9L4+OK
         qEJ3PrnbEF0PYyQgLvE1ZF2EH5Skt6gg0nZYY7LWrofCgyllY2/RLHL/VEE1ybH9k+xt
         6wqQDR5FKTJ+naz2eot/eP6ujp/P2MTFQxbkg=
Message-ID: <9b2b86520812301108k525ca193gac0307b630bdbbd1@mail.gmail.com>
Date: Tue, 30 Dec 2008 19:08:28 +0000
From: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
To: "Grant Grundler" <grundler@google.com>
Subject: Re: 2.6.28: Is there a way to disable sata probing for certain ports?
Cc: "Justin Piszcz" <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <da824cf30812300908x3ff6061cn569203d5163664ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0812300605250.11356@p34.internal.lan>
	 <da824cf30812300908x3ff6061cn569203d5163664ea@mail.gmail.com>
X-Google-Sender-Auth: fd321968bfc45266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 5:08 PM, Grant Grundler <grundler@google.com> wrote:
> On Tue, Dec 30, 2008 at 4:24 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> When I boot from an Intel X25-E SSD, it takes roughly a few seconds;
>> however, items such as:
>>
>> $ dmesg|grep link\ down
>> [    2.447030] ata4: SATA link down (SStatus 0 SControl 300)
>> [    4.481288] ata5: SATA link down (SStatus 0 SControl 0)
>> [    6.501288] ata6: SATA link down (SStatus 0 SControl 0)
>> [    8.522038] ata7: SATA link down (SStatus 0 SControl 0)
>> [   10.552288] ata8: SATA link down (SStatus 0 SControl 0)
>>
>> Scanning for devices on channels that have nothing connected adds to the
>> boot time, is there anyway to turn off/disable scanning for certain ports to
>> help speed the boot process?
>
> Some BIOSs allow one to enable/disable each port individually.
> Have you checked the BIOS config menus for such an option?
>
> drivers/ata/libata-core.c declares "ata_force_param_buf" but I don't
> see any documentation for it despite the reference to
> Documentation/kernel-parameters.txt .

There is.  Search the file for "libata.force".  But it doesn't support
disabling the scan for specific ports; that has yet to be implemented.

<https://kerneltrap.org/mailarchive/linux-kernel/2008/8/11/2900064/thread>

Alan
