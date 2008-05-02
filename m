Return-Path: <linux-kernel-owner+w=401wt.eu-S934381AbYEBPH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381AbYEBPH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761186AbYEBPHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:07:47 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44268 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbYEBPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:07:46 -0400
Date: Fri, 2 May 2008 17:07:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Matthew Wilcox <matthew@wil.cx>
cc: Chris Mason <chris.mason@oracle.com>, jeffschroeder@computer.org,
       Jeff Mahoney <jeffm@suse.com>, Tim Gardner <tim.gardner@canonical.com>,
       linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       John Johansen <jjohansen@suse.de>
Subject: Re: Btrfs v0.14 Released
In-Reply-To: <20080502143811.GC14976@parisc-linux.org>
Message-ID: <alpine.LNX.1.10.0805021706580.6463@fbirervta.pbzchgretzou.qr>
References: <200804291601.32945.chris.mason@oracle.com> <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com> <200805021034.08358.chris.mason@oracle.com> <20080502143811.GC14976@parisc-linux.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-02 16:38, Matthew Wilcox wrote:
>On Fri, May 02, 2008 at 10:34:07AM -0400, Chris Mason wrote:
>> Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell if 
>> the kernel has the patch.  Lets go back to Jeff's suse patch:
>
>Do we really need to support kernels compiled with the apparmour patch
>applied but not enabled?  That would be a custom kernel build, and I get
>the impression that people Just Don't Do That -- if they want a newer
>kernel, they fetch one from kernel.org.  Maybe I'm wrong though.

I think so too. Corollary: if there is a distro that has apparmor
patched into its kernel, then there is [hopefully] a suitable rpm
nearby.
