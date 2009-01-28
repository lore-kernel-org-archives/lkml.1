Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZA1JyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZA1JyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZA1Jx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:53:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbZA1Jx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:53:57 -0500
Date: Wed, 28 Jan 2009 01:51:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, avi@redhat.com,
       Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>
Subject: Re: linux-next: Tree for January 23 (kvm)
Message-Id: <20090128015149.791e10dd.akpm@linux-foundation.org>
In-Reply-To: <497A29D0.2010307@oracle.com>
References: <20090123184826.f2c91472.sfr@canb.auug.org.au>
	<497A29D0.2010307@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009 12:34:24 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Stephen Rothwell wrote:
> > Hi all,
> > 
> > News:  I will be on leave next week, so there will probably be no
> > linux-next release until Feb 2.
> > 
> > Changes since 20090122:
> 
> 
> kvm changes cause this build error on i386:
> 
> when kvm is built as module:
> ERROR: "__moddi3" [arch/x86/kvm/kvm.ko] undefined!
> 
> or when kvm is built into the kernel image:
> lapic.c:(.text+0x19276): undefined reference to `__moddi3'
> 
> 
> I guess it's this line:
> 	ns = ktime_to_ns(remaining) % apic->timer.period;
> 

dammit, I just spent N minutes hunting down the same thing in
the Jan 26 linux-next :(

