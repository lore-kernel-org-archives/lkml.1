Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbZL0OTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbZL0OTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZL0OTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:19:10 -0500
Received: from mail.anarazel.de ([217.115.131.40]:46110 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZL0OTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:19:09 -0500
From: Andres Freund <andres@anarazel.de>
To: ykzhao <yakui.zhao@intel.com>
Subject: Re: lvds downclocking breaks on G45/thinkpad T500
Date: Sun, 27 Dec 2009 15:18:57 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc2-andres-dirty; KDE/4.3.85; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Adam Jackson <ajax@redhat.com>
References: <200912261749.30839.andres@anarazel.de> <200912261841.55828.andres@anarazel.de> <1261919455.4499.31.camel@localhost.localdomain>
In-Reply-To: <1261919455.4499.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912271518.57886.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 December 2009 14:10:55 ykzhao wrote:
> On Sun, 2009-12-27 at 01:41 +0800, Andres Freund wrote:
> > On Saturday 26 December 2009 17:49:29 Andres Freund wrote:
> > > On 2.6.33-rc1 I noticed that the display of my T500 with a G45 reacts
> > > very slowly (you can see the text appearing) and colors take a time to
> > > "solidify". I.e. making a white terminal black takes some seconds. ...
> > > Anything I can do to help analyzing the issue?
> >
> > Thats with recent git checkouts of xorg btw, if thats relevant (which I
> > doubt a bit).
> >
> > The missing config is attached now as well.
> 
> It will be great if you can open a new bug on
> bugs.freedesktop.org(Product=xorg, component = driver/intel) and attach
> the following info:
>     1. add the boot option of "drm.debug=0x06" and attach the output of
> dmesg.
>     2. attach the output of "xrandr -q --verbose"
>     3. attach the vbios.dump, which can be obtained by using the
> following command:
>         echo 1 > /sys/devices/pci0000:00/0000:00:02.0/rom
>         cat /sys/devices/pci0000:00/0000:00:02.0/rom
>     4. attach the output of Xorg.0.log
Is it relevant whether I boot a kernel with the patch really enabled?

Andres
