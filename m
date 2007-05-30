Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbXE3WjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbXE3WjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbXE3WjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:39:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55824 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751369AbXE3WjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:39:16 -0400
Date: Wed, 30 May 2007 15:39:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: RE: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
In-Reply-To: <617E1C2C70743745A92448908E030B2A019298C6@scsmsx411.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0705301537450.1529@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A019298C6@scsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Luck, Tony wrote:

> > WARNING: init/built-in.o - Section mismatch: reference to .init.data: from .sdata after 'root_mountflags' (at offset 0x38)
> 
> I thought that I'd got the section mis-match warnings down to
> just one (and that was in ACPI code, so I sent a patch to Len
> for it).

Hmmm... My compilation of 2.6.21-rc2-mm1 just aborted with:
(used sn2_defconfig).

 LD      .tmp_vmlinux1
`.exit.text' referenced in section `.init.text' of drivers/built-in.o: 
defined in discarded section `.exit.text' of drivers/built-in.o
make[2]: *** [.tmp_vmlinux1] Error 1
make[1]: *** [targz-pkg] Error 2
make: *** [targz-pkg] Error 2

