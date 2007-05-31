Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbXEaUD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbXEaUD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759762AbXEaUDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:03:47 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46356 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762039AbXEaUDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:03:45 -0400
Date: Thu, 31 May 2007 22:04:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Christoph Lameter <clameter@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: BUG: sleeping function called from invalid context at kernel/fork.c:385
Message-ID: <20070531200446.GA27305@uranus.ravnborg.org>
References: <617E1C2C70743745A92448908E030B2A01929DD3@scsmsx411.amr.corp.intel.com> <Pine.LNX.4.64.0705302019040.5583@schroedinger.engr.sgi.com> <465EE7BB.4050605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465EE7BB.4050605@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 11:20:27AM -0400, Prarit Bhargava wrote:
> 
> Something is borken in modpost because I found a bug in the loopback 
> code which is a _REAL_ bug.

Here is the result for an i386 allmodconfig build:
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3966): Section mismatch: reference to .exit.text: (between 'microcode_init' and 'parse_maxcpus')
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3992): Section mismatch: reference to .exit.text: (between 'microcode_init' and 'parse_maxcpus')
  Building modules, stage 2.
Kernel: arch/i386/boot/bzImage is ready  (#4)
  MODPOST 2100 modules
WARNING: drivers/acpi/asus_acpi.o(.init.text+0xb7): Section mismatch: reference to .exit.text: (after 'init_module')
WARNING: drivers/acpi/toshiba_acpi.o(.init.text+0x13a): Section mismatch: reference to .exit.text: (after 'init_module')
WARNING: drivers/block/loop.o(.init.text+0x6b): Section mismatch: reference to .exit.text: (after 'init_module')
WARNING: drivers/isdn/hardware/eicon/divadidd.o(.init.text+0xc4): Section mismatch: reference to .exit.text: (between 'init_module' and 'diddfunc_init')
WARNING: drivers/isdn/hardware/eicon/divas.o(.init.text+0xf4): Section mismatch: reference to .exit.text:divasfunc_exit (between 'init_module' and 'divasfunc_init')
WARNING: drivers/isdn/hardware/eicon/divas.o(.init.text+0x10d): Section mismatch: reference to .exit.text:divasfunc_exit (between 'init_module' and 'divasfunc_init')
WARNING: drivers/isdn/hardware/eicon/divas.o(.init.text+0x148): Section mismatch: reference to .exit.text:divasfunc_exit (between 'init_module' and 'divasfunc_init')
WARNING: drivers/kvm/kvm-intel.o(.init.text+0xbd): Section mismatch: reference to .exit.text: (between 'hardware_setup' and 'vmx_disabled_by_bios')
WARNING: drivers/net/hp100.o(.init.text+0x26a): Section mismatch: reference to .exit.text: (after 'init_module')

	Sam
