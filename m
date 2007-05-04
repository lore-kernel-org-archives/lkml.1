Return-Path: <linux-kernel-owner+w=401wt.eu-S1161619AbXEDSqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161619AbXEDSqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161610AbXEDSq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:46:29 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:17499 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161619AbXEDSq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HzvGE0UoezMY+gWtV6JUpN4kwNT2XrLoGBc7WhufcS4AwZeqM574pVK8qNOeekV3Xtp/wSDRUK05BteGx2tO/g3BM/ASZuUVoIVE09Tq0EmeLwvjOa3eGpsYqDK3ijLPdgJSPY4/FWEF04OwD2CpX7t+FLf29XPLxPQMzDum6vI=
Message-ID: <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
Date: Fri, 4 May 2007 20:46:27 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1178300493.3619.1.camel@amdx2.microgate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <463B4988.9090005@microgate.com>
	 <1178290160.3913.2.camel@amdx2.microgate.com>
	 <5486cca80705040904v786f13dh5614174fcc51c202@mail.gmail.com>
	 <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
	 <463B7534.6000207@microgate.com>
	 <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Paul Fulghum <paulkf@microgate.com> wrote:
> On Fri, 2007-05-04 at 19:25 +0200, Antonino Ingargiola wrote:
>
> > No. Ehmm ... I've an usb keybord and vga monitor on a standard desktop pc.
>
> OK, I'm stumped.
>
> I don't see how my patch could cause the machine to not boot
> and I'm not seeing that behavior here.

I can boot it hitting SysReq+K, but only in text mode. X start but I
can't do login (the mouse moves but I cant enter username and
password). Furthermore if I hit some key in GDM I can't switch to text
console anymore. If I switch to text-mode after boot all seems to
work. Maybe this is related to some important process I kill with the
SysReq key.

I'm quite confident the system blocks on "Setting consoles fonts and
modes.", and thus during the boot script console-screen.h. I'll try to
see which commands blocks...

BTW, I've tried the serial port in text mode. With the patch, flushing
the input results effectively in a complete flush. However after doing
the flush I can't read any char anymore without closing and reopening
the port. I've verified this behavior both communicating between two
serial port and both communicating with an usb-serial device (driver
cdc-acm).

Regards,

  ~ Antonio
