Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab0BZFxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:53:36 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:44368 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0BZFxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:53:35 -0500
Subject: Nick's vfs-scalability patches ported to 2.6.33-rt
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Clark Williams <williams@redhat.com>,
       John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 21:53:28 -0800
Message-ID: <1267163608.2002.9.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Nick,
	I just wanted to let you know I've just finished forward porting Nick's
patches to 2.6.33-rc8-rt2.  Luckily my forward port of Nick's patches to
2.6.33 applies on top of the -rt tree without any collisions, and I've
added a handful of maybe sketchy fixups to get it working with -rt.

You can find the patchset here:
http://sr71.net/~jstultz/dbench-scalability/patches/2.6.33-rc8-rt2/vfs-scale.33-rt.tar.bz2

Here's a chart showing how much these patches help dbench numbers on
ramfs:
http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/ramfs-dbench.png

I've not done any serious stress testing with the patchset yet, but
wanted to post it for your review.

Nick: I'd appreciate any feedback as to if any of my forward porting has
gone awry. I'm still very green with respect to the vfs, so I don't
doubt there are some issues hiding here.

Thomas: Let me know if you want to start playing with this in the -rt
tree. I'm not seeing any warnings with the debugging options on, so I
think I squashed all of those issues, but let me know if you manage to
trigger anything.

thanks
-john


