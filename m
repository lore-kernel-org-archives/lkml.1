Return-Path: <linux-kernel-owner+w=401wt.eu-S1765407AbXHFRUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765407AbXHFRUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762387AbXHFRUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:20:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:45752 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760137AbXHFRUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:20:16 -0400
In-Reply-To: <20070801005640.327226db@the-village.bc.nu>
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <20070725165326.5331.19920.stgit@localhost.localdomain> <46A78322.3080607@ru.mvista.com> <46A78E3F.1030904@ru.mvista.com> <a414f3b506b7802a717e6e2c08befd1e@kernel.crashing.org> <20070801005640.327226db@the-village.bc.nu>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <6546254b267f6d7df93d8df27c6dcfb4@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Vitaly Bordug <vitb@kernel.crashing.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver for CF	interface
Date: Mon, 6 Aug 2007 19:19:56 +0200
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> The hardware is called (E)IDE, the protocol is called ATA.
>> Or that's what I was told -- I think there's some historic
>> revisionism involved, too.
>
> ATA is the interface and standards for the ANSI standards based disk
> attachment. IDE "Integrated Drive Electronics" is a marketing name used
> to cover all sorts of ST412 compatible-ish early interfaces that moved
> the brains onto the disk. IDE doesn't really mean much but "brains on
> disk", ATA is a real standard.

Thanks for refreshing my memory.

We will have to support both names in OF device tree nodes, since
both names are used in many existing device trees.  For new nodes
with no precedent, like this "mmio-ide", let's require the more
correct "ata" name.


Segher

