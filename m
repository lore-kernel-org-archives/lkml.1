Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0CBV2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:28:24 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57671 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0CBV2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:28:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=i7ILrcHT4jPBSp4a4VAOX+h3FVnOVaqHVClhgv0nRb4RtLrQxQaJWtzsrBr/AeAfpB
         2pn9WlzgPkuezWJTyRF3j3gxpzElTc8mS8QW1NaW/V9YwPZQAFuAXllfpedQPwp0UzYI
         KRoALMIECqNDf3T9WjUraEryAQaOi/Sfify6g=
Date: Tue, 2 Mar 2010 13:28:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michael Thayer <Michael.Thayer@Sun.COM>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1]: input: add support for VirtualBox touchscreen
 emulation to the Lifebook driver
Message-ID: <20100302212812.GA13499@core.coreip.homeip.net>
References: <1266923615.3602.85.camel@michael-laptop>
 <20100223175852.GA11301@core.coreip.homeip.net>
 <1266958533.3602.128.camel@michael-laptop>
 <20100224100206.GA5598@core.coreip.homeip.net>
 <1267011989.2831.30.camel@michael-laptop>
 <20100225101705.GF10823@core.coreip.homeip.net>
 <1267562688.2441.7.camel@michael-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267562688.2441.7.camel@michael-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 09:44:48PM +0100, Michael Thayer wrote:
> Hello Dmitry,
> 
> Le jeudi 25 février 2010 à 02:17 -0800, Dmitry Torokhov a écrit :
> > On Wed, Feb 24, 2010 at 12:46:29PM +0100, Michael Thayer wrote:
> > > Le mercredi 24 février 2010 à 02:02 -0800, Dmitry Torokhov a écrit :
> > > > On Tue, Feb 23, 2010 at 09:55:33PM +0100, Michael Thayer wrote:
> > > > > I'm not sure, if we ended up doing a completely new device, how different it
> > > > > would end up being.  Emulating a touchscreen or a tablet makes sense for us as
> > > > > these are both something known, which will work with existing systems without
> > > > > too much tweaking
> > > > > [snip]
> > > > But the virtual mouse is not a touchscreen or a tablet, it behaves
> > > > differently.
> > > What would you suggest emulating that exists in the real world?
> > 
> > There are not many real devices that have teh same characteristics as
> > virtual mouse generating absolute coordinates. Umm, the closest would be
> > a wacom tablet when used with its own mouse.
> We decided in the end to emulate a USB tablet, as some other virtualisers do.
> It works well out of the box with recent Linux distributions, and while older
> ones recognise it as a touchpad (in fact they use it through /dev/input/mice),

Yes, mousedev will provide workable approximation of standard mouse for
a device that provides absolute events. BTW, the fact that data from a
device is available from /dev/input/mice does not mean that device was
recognized as a mouse, a touchpad or something else. It just means that
kernel is able to approximate device as a standard PS/2 Expolorer mouse.

> it still provides a reasonable user experience until the user has installed our
> guest drivers.

It is your call but I would much rather if you worked on fixeng evdev to
work with your virtual device rather than having to install a new X
driver and going through the hoops trying to detect which one should be
used on a particular box. At least on Linux...

Thanks.

-- 
Dmitry
