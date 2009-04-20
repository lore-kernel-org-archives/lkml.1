Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZDTMgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZDTMgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZDTMfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:35:50 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:50047 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbZDTMft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:35:49 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 08:35:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jmrvU6JNri4Y7fliMO3xyF0MHlHKtQwtkIorK+khd4WsnjFEqdBkSSxMvMWkm/lOy+
         FKV3zfvtdQNRxdgL8P3UcN1bsvJeuHWNi6kgEOKeFOr7RzoMWE1qighD85y329y4wR37
         R0oafgOaBSUY858qd5P8yvyYErqbB/lWH5oI0=
MIME-Version: 1.0
In-Reply-To: <f73f7ab80904171732n41832d0hc62978e57bbcc32e@mail.gmail.com>
References: <f73f7ab80904171732n41832d0hc62978e57bbcc32e@mail.gmail.com>
Date: Mon, 20 Apr 2009 08:29:24 -0400
X-Google-Sender-Auth: d921c4d2acbd36db
Message-ID: <625fc13d0904200529l152b8d75g33c3f940de1b2920@mail.gmail.com>
Subject: Re: Porting the ibm_newemac driver to use phylib (and other PHY/MAC 
	questions)
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: netdev <netdev@vger.kernel.org>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 8:32 PM, Kyle Moffett <kyle@moffetthome.net> wrote:
> Hello,
>
> I'm currently fiddling with a custom embedded prototype board using
> the ibm_newemac driver with some currently-unsupported PHYs.  Those
> PHYs *are* supported by phylib, but the emac driver seems to have its
> own PHY layer cribbed from the sungem driver.  I'm curious if there's
> some particular reason it hasn't been ported (aside from "nobody has
> bothered yet").

IIRC, Ben had some issues with how phylib and the EMAC would need to
interact.  Not sure if he has those written down somewhere or not.
(CC'd).

> I've temporarily hacked a PHY driver together for the moment, but it
> would be much easier for us to maintain and update our board if the
> PHY drivers were integrated.  As a result I'm also interested in how
> complicated it might be to port the driver (and possibly sungem as
> well) over to phylib, if that is indeed feasible.  Also, if I end up
> going that route, are there others available with other hardware
> variants who would be willing to test my patches on their boards?

I have a large variety of boards that I can test with since the entire
4xx line relies on this driver for on-board network.

josh
