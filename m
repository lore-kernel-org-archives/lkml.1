Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZI3PmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZI3PmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZI3PmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:42:23 -0400
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:56903 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754226AbZI3PmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:42:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=YloXuJLct7PoJ2rVx4DssfcX2BZXPNmi8kFwmKUjrWf34oJoTjWmSKqmhQU3MWex;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <6024051.1254325345120.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
Date: Wed, 30 Sep 2009 11:42:24 -0400 (EDT)
From: "Steven A. DuChene" <linux-clusters@mindspring.com>
Reply-To: "Steven A. DuChene" <linux-clusters@mindspring.com>
To: linux-kernel@vger.kernel.org
Subject: newer non-distro kernels don't boot / unpack?
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: ea4808abc3da2865808dd114cae72f675e89bb4777695beb00ff6c36d42eb1fae1d0599fdd84e80e05cc4cc8fdab531c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a A13G motherboard from PCChips that has a AMD Athlon 3600+
dual core CPU in it. I have fedora core 9 installed and running
fine on it. FC9 comes with a 2.6.25-14.fc9.x86_64 kernel installed.
The motherboard has a NVidia MCP61 chipset on it and as I said
everything built onto the motherboard including sound, usb, and
network chips work just fine with the FC9 included kernel.

I have 15+ years of Linux experience and have built many kernels
of my own in the past however I have been frustrated for a few
months now (since Jan/Feb of this year) at getting a self-compiled
kernel to run on this system. I have built 2.6.25.5, 2.6.28.1 and
yesterday 2.6.31.1 and nothing seems to work.

When I try booting the kernel after making the usual grub entry
it does the following:

Booting 'deskamd30mne (2.6.31.1-amddesk1)'

root (hd0,0)
Filesystem type is ext2fs, partition type 0x83
kernel /vmlinux-2.5.31.1-amddesk1 ro root=/dev/sda3 rhgb quiet

and then the whole thing just sits there forever with no additional
activity. I have tried turning off and on various debugging
stuff during the compile but nothing seems to have any affect
on this. When the regular FC9 distro kernel boots the next lines
I would normally see on the screen would be about the initrd.

I can try booting some live-cd type of thing but I am guessing
they will work fine. BTW, I have built the various filesystem
and device drivers I need so as to not need an initrd file.

Anyone have any suggestions or thoughts?

Also I am not subscribed to the linux-kernel mailing list so please
CC me on any replies. I will try to watch the LKML archives however.

Thanks for any help, suggestions or assistance.
--
Steven DuChene


