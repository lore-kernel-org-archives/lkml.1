Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbZHGTNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbZHGTNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbZHGTNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:13:14 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:52577 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928AbZHGTNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:13:13 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 15:13:13 EDT
Message-ID: <4A7C7CC5.8040306@gmx.de>
Date: Fri, 07 Aug 2009 21:13:09 +0200
From: Bernhard Walle <bernhard.walle@gmx.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Amerigo Wang <amwang@redhat.com>, Neil Horman <nhorman@redhat.com>,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andi Kleen <andi@firstfloor.org>, Bernhard Walle <bwalle@suse.de>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>	<m1eirqtmey.fsf@fess.ebiederm.org>	<20090805140408.GJ7259@hmsreliant.think-freely.org>	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com>	<m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com>	<m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com>	<m1iqh1nxv3.fsf@fess.ebiederm.org> <m13a85nxab.fsf@fess.ebiederm.org>
In-Reply-To: <m13a85nxab.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=DDAF6454
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Relay-User: bernhard@bwalle.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman schrieb:
> Hmm.  I half take it back.  How is crashkernel=auto and then shrinking
> the reserved size better than the extended syntax Bernhard Walle
> introduced nearly two years ago?

BTW: Ubuntu ships by default with

	crashkernel=384M-2G:64M@16M,2G-:128M@16M

What is the complexity for the user? I didn't edit /boot/grub/menu.lst,
I just installed kexec-tools and a few other kdump-related packages, and
then this was in my menu.lst.

Don't make the kernel complex. Make the userspace complex.


Regards,
Bernhard


