Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYBMOjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYBMOjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYBMOi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:38:58 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:29754 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYBMOi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:38:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sUa5uZz+EI846SrY+ZmK/qZoJTK0ubrNBh3rqM0zqRUH9RKSLUxtoeaECpSq6FbZdxTXUJlfNtpvxQgbWYSlGTszo9HgQnJR4QP2gQ4dfwvKtp4fyNxY6BGizj2gdIlnBiNNMJ4dSdnMRMOtQQJXpMnHJnjq9kiBcfyhqcWBrF0=
Message-ID: <c4e36d110802130638i5057b49by280ab0b2c415064a@mail.gmail.com>
Date: Wed, 13 Feb 2008 15:38:55 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Qemu & KVM bug
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I get this bug in my log whenever I start qemu-kvm - I do not use kqemu
module - so it's with plain kernel modules.
If more details are needed - just ask.
(Cpu; C2D)

Bye

Zdenek



BUG: sleeping function called from invalid context at kernel/rwsem.c:48
in_atomic():1, irqs_disabled():0
INFO: lockdep is turned off.
Pid: 26600, comm: qemu-kvm Not tainted 2.6.25-rc1 #29

Call Trace:
 [<ffffffff81064873>] ? __debug_show_held_locks+0x23/0x30
 [<ffffffff81036765>] __might_sleep+0xe5/0x110
 [<ffffffff812f21b0>] down_write+0x20/0x70
 [<ffffffff88271a3c>] :kvm_intel:vmx_create_vcpu+0x48c/0x61c
 [<ffffffff810b5d92>] ? fd_install+0x52/0x60
 [<ffffffff8824edce>] :kvm:kvm_arch_vcpu_create+0xe/0x10
 [<ffffffff8824dca2>] :kvm:kvm_vm_ioctl+0x122/0x220
 [<ffffffff8824c770>] ? :kvm:kvm_dev_ioctl+0x80/0x1c0
 [<ffffffff810c67b1>] vfs_ioctl+0x31/0xa0
 [<ffffffff810c6aa3>] do_vfs_ioctl+0x283/0x2f0
 [<ffffffff810c6ba9>] sys_ioctl+0x99/0xa0
 [<ffffffff8100c8ae>] tracesys+0xdc/0xe1

SIPI to vcpu 1 vector 0x10
Ignoring de-assert INIT to vcpu 1
SIPI to vcpu 1 vector 0x06
SIPI to vcpu 1 vector 0x06
kvm: emulating exchange as write
