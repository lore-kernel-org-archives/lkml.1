Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYAMSEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYAMSEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYAMSEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:04:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:4257 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYAMSEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:04:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QGYk7Le3Bqs62rlqxxv7RSayBpE+03NUuUQICPXtlzJQfQ4YVX9fdR0J0ObesepZ8EThUEp+f6tAkFCRkoteg6r+Ly7nwzWWD3GOrvpXsL09TTfk+z3sBaJocSkfwEuhLa3jrE3tpJEvTGRJq3AvTYf+CwYdYP6z00bCw/gaEfI=
Message-ID: <9e4733910801131004i669276e2pde04b195dd10bd90@mail.gmail.com>
Date: Sun, 13 Jan 2008 13:04:13 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [i2c] [PATCH] update module-init-tools to support the i2c subsystem
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080113184337.5d4cd546@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910712171839h214e0bc3q179266c86e5987b1@mail.gmail.com>
	 <20080113152735.5dca46a1@hyperion.delvare>
	 <9e4733910801130714m1be16826jf240171972324d16@mail.gmail.com>
	 <20080113163543.16e3d26b@hyperion.delvare>
	 <9e4733910801130826l799e4897pe7380ccb973b5fd0@mail.gmail.com>
	 <20080113184337.5d4cd546@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> On Sun, 13 Jan 2008 11:26:07 -0500, Jon Smirl wrote:
> > On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > > On Sun, 13 Jan 2008 10:14:14 -0500, Jon Smirl wrote:
> > > > On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > > > > On Mon, 17 Dec 2007 21:39:37 -0500, Jon Smirl wrote:
> > > > > > Follow on to: "Series to add device tree naming to i2c"
> > > > > > Teach module-init-tools about the i2c subsystem.
> > > > >
> > > > > Can you please explain what this patch does and why it is needed?
> > > >
> > > > It generates the entries needed for the user space module tools to
> > > > work with the aliases. For example modprobe/depmod. It is a standard
> > > > part of the kernel module system.
> > >
> > > What entries, where? What can you do after applying your patch that you
> > > couldn't do before?
> >
> > The drivers you are testing with don't depend on other drivers.
>
> They do. I'm testing with the lm90 driver, which depends on the hwmon
> driver. Both load automatically when the underlying i2c-parport driver
> instantiate an "adm1032" i2c device.

I don't know exactly what those modules tables are used for. I just
copied what the other subsystems do. Maybe they are used when you make
an initrd to know which drivers to copy into the image.

-- 
Jon Smirl
jonsmirl@gmail.com
