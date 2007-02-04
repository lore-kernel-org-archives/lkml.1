Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbXBDCBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbXBDCBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 21:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXBDCBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 21:01:52 -0500
Received: from yuma.hostsharing.net ([212.42.230.35]:45637 "EHLO
	yuma.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbXBDCBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 21:01:51 -0500
Date: Sun, 4 Feb 2007 03:00:46 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-rc7: hid on PPC
Message-ID: <20070204020046.GA17041@frodo.home.lxtec.de>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070202205151.GA3212@aragorn.home.lxtec.de> <Pine.LNX.4.64.0702040046280.22958@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702040046280.22958@jikos.suse.cz>
Organization: LXTEC
X-gnupg-key-fingerprint: BE65 85E4 4867 7E9B 1F2A  B2CE DC88 3C6E C54F 7FB0
X-Editor: VIM - Vi IMproved 7.0 (2006 May 7, compiled Jan 21 2007 22:03:27)
User-Agent: Mutt/1.5.13-muttng (2007-01-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Feb 2007 the mental interface of
Jiri Kosina told:

> On Fri, 2 Feb 2007, Elimar Riesebieter wrote:
> 
> > it would be great, if we can choose pb_fnmode while configure the 
> > kernel. I have a PowerBook5,6 but want fkeysfirst. So I have to # echo 2 
> > >| /sys/module/hid/parameters/pb_fnmode by hand after each boot. The 
> > module-parm pb_fnmode doesn't work either in /etc/modules nor in a 
> > modprobe instruction while boot. An modprobe -r usb-hid hid; sleep 2; 
> > modprobe hid pb_fnmode=2; modprobe usb-hid works on a fresh booted 
> > machine. Else module-parm isn't available with a built-in hid, though.
> 
> Hi Elimar,
> 
> sorry, but I don't seem to understand your problem. There are two 
> situations - either you have hid bultin in kernel, or compiled as a 
> module. In the first case, you simply modify the kernel boot commandline 
> to contain a string 
> 
> 	hid.pb_fnmode=2 

This works fine, thanks ;)

> and that's it. In the latter case, you add something like 
> 
> 	options hid     pb_fnmode=2
> 
> into the /etc/modprobe.conf file (or you can use any distro-specific way 
> to pass parameters to modules, such as /etc/modprobe.d). This is standard 
> way to do things, and it works also with hid.

Hmmm, I've had "options hid     pb_fnmode=2" in /etc/modprobe.d/hid,
which did not work. But "options hid pb_fnmode=2" in
/etc/modprobe.conf works well ;)

> I don't think there is a need to have this as a separate kernel 
> configuration option.

Thanks, sorry for the noise.

Elimar

-- 
  Do you smell something burning or ist it me?

