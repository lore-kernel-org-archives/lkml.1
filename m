Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbXHTXbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbXHTXbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXHTXbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:31:35 -0400
Received: from ozlabs.org ([203.10.76.45]:52126 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbXHTXbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:31:34 -0400
Subject: Re: [PATCH 0/4] Virtual Machine Time Accounting
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, John Stoffel <john@stoffel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <46C9BD8F.4070807@goop.org>
References: <46C99371.7070705@bull.net>
	 <18121.39541.790665.686081@stoffel.org> <46C9A7AB.1030003@bull.net>
	 <46C9BD8F.4070807@goop.org>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 09:30:56 +1000
Message-Id: <1187652656.19435.143.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 09:13 -0700, Jeremy Fitzhardinge wrote:
> Laurent Vivier wrote:
> > functionnalities:
> >
> > - allow to measure time spent by a CPU in a virtual CPU.
> > - allow to display in /proc/state this value by CPU
> > - allow to display in /proc/<pid>/state this value by process
> > - allow KVM to use these 3 previous functionnalities
> >   
> 
> So, currently time spent in a kvm guest is accumulated as qemu-kvm
> usertime, right?  Given that qemu knows when its running in qemu vs
> guest context, couldn't it provide the breakdown between user and guest
> time (ditto lguest)?

No, unfortunately it's accumulated as system time.

Rusty.


