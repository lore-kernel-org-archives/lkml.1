Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYAMRnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYAMRnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 12:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYAMRnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 12:43:39 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:56528 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149AbYAMRni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 12:43:38 -0500
Date: Sun, 13 Jan 2008 18:43:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH] update module-init-tools to support the i2c
 subsystem
Message-ID: <20080113184337.5d4cd546@hyperion.delvare>
In-Reply-To: <9e4733910801130826l799e4897pe7380ccb973b5fd0@mail.gmail.com>
References: <9e4733910712171839h214e0bc3q179266c86e5987b1@mail.gmail.com>
	<20080113152735.5dca46a1@hyperion.delvare>
	<9e4733910801130714m1be16826jf240171972324d16@mail.gmail.com>
	<20080113163543.16e3d26b@hyperion.delvare>
	<9e4733910801130826l799e4897pe7380ccb973b5fd0@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 11:26:07 -0500, Jon Smirl wrote:
> On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > On Sun, 13 Jan 2008 10:14:14 -0500, Jon Smirl wrote:
> > > On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > > > On Mon, 17 Dec 2007 21:39:37 -0500, Jon Smirl wrote:
> > > > > Follow on to: "Series to add device tree naming to i2c"
> > > > > Teach module-init-tools about the i2c subsystem.
> > > >
> > > > Can you please explain what this patch does and why it is needed?
> > >
> > > It generates the entries needed for the user space module tools to
> > > work with the aliases. For example modprobe/depmod. It is a standard
> > > part of the kernel module system.
> >
> > What entries, where? What can you do after applying your patch that you
> > couldn't do before?
> 
> The drivers you are testing with don't depend on other drivers.

They do. I'm testing with the lm90 driver, which depends on the hwmon
driver. Both load automatically when the underlying i2c-parport driver
instantiate an "adm1032" i2c device.

-- 
Jean Delvare
