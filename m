Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbZG1AVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbZG1AVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZG1AVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:21:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33035 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752368AbZG1AVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:21:40 -0400
Date: Tue, 28 Jul 2009 01:19:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Morris <jmorris@namei.org>
Cc: James Carter <jwcart2@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, Stephen Smalley <sds@tycho.nsa.gov>,
       spender@grsecurity.net, Daniel J Walsh <dwalsh@redhat.com>,
       cl@linux-foundation.org, Arjan van de Ven <arjan@infradead.org>,
       kees@outflux.net, Chad Sellers <csellers@tresys.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, mingo@elte.hu
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090728011943.589176cb@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LRH.2.00.0907221953190.15799@tundra.namei.org>
References: <1248132223.2654.278.camel@localhost>
	<alpine.LRH.2.00.0907211258110.32400@tundra.namei.org>
	<1248187482.19456.90.camel@moss-lions.epoch.ncsc.mil>
	<alpine.LRH.2.00.0907221953190.15799@tundra.namei.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A dumb question perhaps, but while addling my brain over the tty layer I
was wondering if for the specific case of jump through NULL (which seems
to be the most common but by no means only problem case that gets
exploited) is there any reason we can't set a default breakpoint for
executing 0 and fix that up as a trap in the kernel ?

Even user code that needs zero page mapped such as BIOS hackery doesn't
actually jump through zero often if ever, and would be a userspace not a
kernel space trap source so could be fixed up.

Just a random "I've been staring at code too long today" thought ?

Alan
