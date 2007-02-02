Return-Path: <linux-kernel-owner+w=401wt.eu-S1946073AbXBBVNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946073AbXBBVNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946081AbXBBVNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:13:34 -0500
Received: from yuma.hostsharing.net ([212.42.230.35]:43334 "EHLO
	yuma.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946073AbXBBVNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:13:34 -0500
X-Greylist: delayed 1294 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Feb 2007 16:13:33 EST
Date: Fri, 2 Feb 2007 21:51:51 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: jkosina@suse.cz
Subject: 2.6.20-rc7: hid on PPC
Message-ID: <20070202205151.GA3212@aragorn.home.lxtec.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	jkosina@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: LXTEC
X-gnupg-key-fingerprint: BE65 85E4 4867 7E9B 1F2A  B2CE DC88 3C6E C54F 7FB0
X-Editor: VIM - Vi IMproved 7.0 (2006 May 7, compiled Jan 22 2007 17:50:57)
User-Agent: Mutt/1.5.13-muttng (2007-01-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

it would be great, if we can choose pb_fnmode while configure the
kernel. I have a PowerBook5,6 but want fkeysfirst. So I have to
# echo 2 >| /sys/module/hid/parameters/pb_fnmode
by hand after each boot. The module-parm pb_fnmode doesn't work
either in /etc/modules nor in a modprobe instruction while boot.

An modprobe -r usb-hid hid; sleep 2; modprobe hid pb_fnmode=2;
modprobe usb-hid works on a fresh booted machine.

Else module-parm isn't available with a built-in hid, though.

Thanks

Elimar

-- 
  Do you smell something burning or ist it me?
  Please reply me directly while I am not subsribed, thanks.
