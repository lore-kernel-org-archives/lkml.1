Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYDUPkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYDUPkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYDUPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:40:09 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:64555 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbYDUPkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=M2xfuEIi7mb92yYBLJjBfW0AaefjtTVJRdNlQ36jL7wi9lCjQXAF/iGr1Ml6+G8llKRqS17ATkWxDr85D723XAVld5A9Y2tff29mGhpJTJJfGc/uzml65iDQTnn8y1Ciz5jyEauZX/dkYL8cMh8VI/aN+7JrSxRRgrr63lwcQsA=
Date: Mon, 21 Apr 2008 11:39:47 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
Subject: Re: [PATCH 22/37] Input: add PS/2 serio driver for AVR32 devices
Message-ID: <20080421153947.GB6884@anvil.corenet.prv>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com> <9f9439e92a7fb057d31a19636b99e43306192756.1208783694.git.dmitry.torokhov@gmail.com> <1208784838.30244.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208784838.30244.2.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 03:33:58PM +0200, Hans-Christian Egtvedt wrote:
> On Tue, 2008-04-15 at 01:30 -0400, Hans-Christian Egtvedt wrote:
> > Add support for the PSIF peripheral on AVR32 AP7 devices.  It is implemented
> > as a serio driver and will behave like a serio 8042 device.
> > 
> > The driver has been tested with a Dell keyboard capable of running on 3.3
> > volts and a Logitech mouse on the STK1000 + STK1002 starter kit.  The Logitech
> > mouse was hacked by cutting the cord and using a bi-directional voltage
> > converter to get the required 5 volt I/O level.
> > 
> > For more information about the PSIF module, see the datasheet for AT32AP700X at
> > http://www.atmel.com/dyn/products/datasheets.asp?family_id=682
> > 
> > Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > ---
> 
> <snipp serio driver for AVR32>
> 
> > +MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
> 
> This address has been changed, please apply the attached patch.
> 
> > +MODULE_DESCRIPTION("Atmel AVR32 PSIF PS/2 driver");
> > +MODULE_LICENSE("GPL");
> 
> PS! I think my old address even bounces a message, sorry about that :(
> 

Applied, thanks.

-- 
Dmitry
