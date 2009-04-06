Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZDFJMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZDFJMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZDFJMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:12:00 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:50333 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZDFJL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lu5UamJS/50T4jC9u5oQ3gJ3+GtNSGrNWOSVMCUVOIvZ5lbOubu5g6QlT4/WGhO57n
         YASYFr+TBFJP1uUxM2eei+EbhJM+y08C4Tgy1yRkgaWUjnjdRsHvpdClVEzcQS91qGDh
         q23elu877OaRGJLH7+75LpNeZkA4gtijTCwvY=
MIME-Version: 1.0
In-Reply-To: <20090406022356.GA866@kroah.com>
References: <19ac3f7a0904051104h1abc4cf3rae6dc1a027207831@mail.gmail.com>
	 <20090406022356.GA866@kroah.com>
Date: Mon, 6 Apr 2009 11:11:55 +0200
X-Google-Sender-Auth: 6c649381597edf5f
Message-ID: <19ac3f7a0904060211s5a79b659tf8ac315010151dbb@mail.gmail.com>
Subject: Re: USB disconnect, address 6
From: Jon Grant <jg@jguk.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

2009/4/6 Greg KH <greg@kroah.com>:
> On Sun, Apr 05, 2009 at 07:04:45PM +0100, Jon Grant wrote:
>> Hello
>>
>> Would there be a way to propagate the device name back from the scsi
>> system to the usb so it can name the device which is disconnected in
>> the output? This saves needing to go hunting to find what the
>> disconnected device was.
>
> What do you mean, all the info needed is already in the messages below,
> what more do you need?

The idea was that the disconnect could give more information.
Otherwise it's necessary to go hunting back up the log to track down
which USB device was the one disconnected (which works fine, but isn't
ideal for time consumed doing this regularly).

[...]
>> Apr  5 18:56:58 data-laptop kernel: [65451.669308] usb 5-1: USB disconnect, address 6
>
>
> confused,

If it said instead:

Apr  5 18:56:58 data-laptop kernel: usb 5-1: USB disconnect, address 6
(Samsung  Mighty Drive)

Would this not be clearer?

Please include my email address in any replies.
Regards, Jon
