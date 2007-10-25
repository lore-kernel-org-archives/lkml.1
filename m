Return-Path: <linux-kernel-owner+w=401wt.eu-S1760349AbXJYWnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349AbXJYWnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbXJYWmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:42:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:40659 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254AbXJYWmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:42:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KciPUJe4S7EY5oPupvQQoQT+ktw4cgtvscTPulYXEBesR45agc9xIvp5xsiZ/PiHDZxRajjeNFI+xttvQSoGQXqXj/RhGE8+aAEA6h1NZ9QfCDN0QqpqruunEXD0fHJN7VsSab1i04h4t0/MyXCpwWfsqDHbFVloPQjgaYtvrHw=
Message-ID: <fc94aae90710251542j54e0dfbfh90ef049ed6aad33c@mail.gmail.com>
Date: Thu, 25 Oct 2007 23:42:47 +0100
From: "Michael Lothian" <mike@fireburn.co.uk>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Possibility of adding -march=native to x86
Cc: "Gabriel C" <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071025214647.GX30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net>
	 <20071025185022.GP30533@stusta.de>
	 <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com>
	 <20071025191723.GQ30533@stusta.de>
	 <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com>
	 <20071025195020.GS30533@stusta.de>
	 <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com>
	 <4720FF2B.9020802@googlemail.com>
	 <fc94aae90710251430s669418e5v72282ff5f8a5691e@mail.gmail.com>
	 <20071025214647.GX30533@stusta.de>
X-Google-Sender-Auth: 82cfe245472fc9ee
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What exactly is irritating?
> Please name the problems so that they can be fixed.
>
> > Detecting the cpu and using march=native could be all part of that
>
> You don't need march=native for this.
>
> You have to set the right config option for your CPU and you
> automatically get the right compiler options.

Well when doing a lspci here are some specific examples:



03:02.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)

What modules would you think you'd need to compile to get this to work?

No it's not budget card os buget card ci even though the card its self
has no cam interface



00:14.2 Audio device: ATI Technologies Inc SB600 Azalia

Is there any indication from this piece of info that the intel hda
driver is required?



00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA

This uses AHCI



As for the i2c and the hardware monitoring support well that's mostly guess work


Half the time it's easier doing a lsmod when booted on a livecd and
trying to figure out what options are required from the module names
which sometime can be just as tricky.

Why not auto detect the CPU the same way GCC does and automatically
set the correct CPU and then go the whole hog and let GCC use the
correct flags if it's new enough using native

I can't understand why you wouldn't find this useful when setting up a
customised kernel.

Maybe even having a make addnewhardware option to quickly add extra
devices to your config file.

Mike
