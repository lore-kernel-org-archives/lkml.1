Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYHTO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYHTO2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbYHTO2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:28:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbYHTO2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:28:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080819134842.GJ8852@cs181140183.pp.htv.fi>
References: <20080819134842.GJ8852@cs181140183.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       linux-kernel@vger.kernel.org
Subject: Re: mn10300: status of ASB2305 support?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 20 Aug 2008 15:28:12 +0100
Message-ID: <10981.1219242492@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> I tried to build an ASB2305 kernel [1], and there are many compile 
> errors due to references to nonexisting files like asm/cpu/timer-regs.h
> 
> What is the status of ASB2305 support?
> Is it dead?
> Or are there updates somewhere that should get merged into the kernel?

I have patches, but they're dependent on some other patches that are currently
awaiting MEI's sign-off.

Also, my ASB2305 board is broken.  The PCI-PCI bridge chip that allows access
to stuff plugged into its PCI slots is malfunctioning.

So feel free to mark it broken in Kconfig.  I'll ask MEI if I should retire
the board or if I can get a replacement backplane.  The ASB2303 doesn't allow
me to attach disk drives.

David
