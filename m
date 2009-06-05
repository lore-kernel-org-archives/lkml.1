Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZFENwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZFENwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZFENw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:52:28 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36856 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZFENw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lmI8B442PHd4EMnKfDCNz7n3ULnJqwhv7k7EMsdZLXoJXyrYzzRk85Cc0jGLmgIDxI
         XlOmFHgYXo8Ta/n+WcYuc7MrvMCU+JBis9KOxuNe6LrbFfs9mqEzzHN2yVKyl9z6T1mL
         diFF/1HJ0gKKlUae11kPB/GTnXTmrFUrvN4Tg=
From: Florian Fainelli <florian@openwrt.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 8/8] 8250: add Texas Instruments AR7 internal UART
Date: Fri, 5 Jun 2009 15:52:24 +0200
User-Agent: KMail/1.9.9
Cc: Linux-MIPS <linux-mips@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org
References: <200906041622.47591.florian@openwrt.org> <20090604222020.GA14843@alpha.franken.de>
In-Reply-To: <20090604222020.GA14843@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906051552.25529.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Thomas,

Le Friday 05 June 2009 00:20:20 Thomas Bogendoerfer, vous avez écrit :
> On Thu, Jun 04, 2009 at 04:22:46PM +0200, Florian Fainelli wrote:
> > We discussed that in private, there are a couple of things
> > to fix in order to get 8250 working properly with TI AR7 HW.
> > If you can still merge that bit, this would ease future work, thanks !
>
> I still have a tree here, which works without any changes to the 8250
> serial driver on a TNETD7300 device.

That specific patch just adds an AR7 port to the 8250 uart driver. My 
TNETD7300 really needs patching in the 8250 driver to work properly, Alan 
already suggested to perform some testing. I still think there is a HW bug 
with different silicon revisions.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
