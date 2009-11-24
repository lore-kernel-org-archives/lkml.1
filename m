Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbZKXLzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbZKXLzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbZKXLzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:55:41 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60923 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbZKXLzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=B0eRA6smldYKRSZI6QAU2czjkBvlhzzyFavWpvuuKMkqfXInn7mog7FEwg9wgye3Fd
         tqWvY32iY2C5nbUZnMnCw+wImBGtpZ+a6fC0Nrehz7+liVP5p6uXmQSEVvmamNMNaQuZ
         oPaBodlGpb5FWLx7hC77cFDEl8gBlTtQyQtRE=
MIME-Version: 1.0
In-Reply-To: <be7a9f3d0911240331n61637196gf243af4e607403ff@mail.gmail.com>
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
	 <200911241032.29820.jbe@pengutronix.de>
	 <be7a9f3d0911240331n61637196gf243af4e607403ff@mail.gmail.com>
Date: Tue, 24 Nov 2009 09:55:46 -0200
X-Google-Sender-Auth: 3cc4aadb9b4c588e
Message-ID: <be7a9f3d0911240355s5a85545amb32d25a7df7e09f0@mail.gmail.com>
Subject: Re: Vortex86SX: only works with irqpoll
From: Otavio Salvador <otavio@ossystems.com.br>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Juergen,

On Tue, Nov 24, 2009 at 9:31 AM, Otavio Salvador
<otavio@ossystems.com.br> wrote:
> I'll take a look on the dmesg output and see if I see something interesting :-)

In fact I did find some interesting issues. First:

PCI: Probing PCI hardware
pci 0000:00:07.0: default IRQ router [17f3:6031]
pci 0000:00:0a.0: BAR 0: address space collision on of device
[0x0e2000-0x0e2fff]
pci 0000:00:0a.0: BAR 0: can't allocate resource
pci 0000:00:0a.1: BAR 0: address space collision on of device
[0x0e3000-0x0e30ff]
pci 0000:00:0a.1: BAR 0: can't allocate resource
pci 0000:00:0b.0: BAR 0: address space collision on of device
[0x0e0000-0x0e0fff]
pci 0000:00:0b.0: BAR 0: can't allocate resource
pci 0000:00:0b.1: BAR 0: address space collision on of device
[0x0e1000-0x0e10ff]
pci 0000:00:0b.1: BAR 0: can't allocate resource
NET: Registered protocol family 2

This is the same collision I have. Another interesting issue is that
your disk is using the USB bus while mine uses IT821x.

Is your network working? mine does not (inside of Linux but does for
tftp booting).

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
