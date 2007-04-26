Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbXDZUXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbXDZUXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXDZUXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:23:23 -0400
Received: from gw.goop.org ([64.81.55.164]:55416 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031495AbXDZUXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:23:19 -0400
Message-ID: <46310A58.4090207@goop.org>
Date: Thu, 26 Apr 2007 13:23:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Xen-devel <xen-devel@lists.xensource.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>
Subject: Xen/paravirt_ops kernel available for testing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm pleased to announce a Xen paravirt_ops kernel available for testing
at http://xenbits.xensource.com/ext/paravirt_ops/.

These kernels are based on this morning's 2.6.21, along with all the
paravirt_ops + Xen patches.  The pre-built i386 kernel RPM is based on
the FC6 configuration, and it has both Xen and VMI paravirt_ops support
enabled.  Unfortunately the RPM is a bit rough, and you'll need to
generate an initrd and update your boot-loader to make it bootable.  To
boot under Xen, use /boot/vmlinux-.gz as the kernel image.

This is definitely a testing snapshot release, but it has had a bit of
testing.  I've been using it running native on my main work machine, and
it behaves exactly like a non-paravirt kernel.  It has also been tested
under Xen on XenRT, XenSource's automated testing infrastructure, where
it passes almost everything.

There are a couple of expected BUG messages which appear on boot: one in
init_sched_clock, and one in xen_apic_read.  Both are harmless warning
messages, and will be removed shortly.  (However, if you see more than
one xen_apic_read warning, please send me the details along with your
kernel config.)

Please see the RELEASE*.txt for release notes.

    J
