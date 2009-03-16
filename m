Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbZCPSDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbZCPSDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbZCPRzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:55:54 -0400
Received: from gw.goop.org ([64.81.55.164]:46909 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761049AbZCPRzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:55:53 -0400
Message-ID: <49BE92A6.2070406@goop.org>
Date: Mon, 16 Mar 2009 10:55:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: bderzhavets@yahoo.com
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] Re: tip.git regression from "vsprintf: unify the
 format decoding layer for its 3 users"
References: <459064.87775.qm@web56105.mail.re3.yahoo.com>
In-Reply-To: <459064.87775.qm@web56105.mail.re3.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris Derzhavets wrote:
> Performed:-
>
> root@ServerIntrepid:/usr/src/linux-2.6-xen# git reset --hard 
> remotes/origin/xen/dom0/hackery
> HEAD is now at a38db50 Merge commit 'tip/core/printk' into 
> xen/dom0/hackery
> make clean
> make
> make modules_install install
> mkinitramfs -o /boot/initrd-2.6.29-rc7-tip.img 2.6.29-rc7-tip
>
> Booted with new kernel under Xen (19355) and get same bug in place.
> Cannot shutdown any PV DomU . Xen Host dies.
>
OK, so we're talking about a new bug now, right?

When you say "Xen Host dies", do you mean that Xen itself crashes?  Or 
that the dom0 kernel crashes?  Hangs?  Non-responsive?

Do you have a serial console?

    J
