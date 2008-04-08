Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYDHIKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYDHIKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYDHIKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:10:00 -0400
Received: from styx.suse.cz ([82.119.242.94]:44765 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751863AbYDHIJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:09:59 -0400
Date: Tue, 8 Apr 2008 10:09:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
In-Reply-To: <c4e36d110804071553x6ce219b2tc1e27ce5d3a722af@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804081009040.3896@jikos.suse.cz>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> 
 <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz>  <20080407222352.GG16647@one.firstfloor.org>
  <200804080029.31102.rjw@sisk.pl>  <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
 <c4e36d110804071553x6ce219b2tc1e27ce5d3a722af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Zdenek Kabelac wrote:

> To avoid some mystery - these two warns precede warnings I've initially 
> posted here - the reason why I've not posted also these 2 kvm related 
> warns is that kvm maintainers already know about this problem and said 
> in the past that they will eventually fix them (If I remember correctly)
> Warnings and bug looked somewhat unrelated - but I could be wrong and
> the mystery irq could be mangles in kvm....

Yes, please try to reproduce without KVM. It could happen that some KVM 
code wrongly enabled IRQs somewhere.

Thanks,

-- 
Jiri Kosina
SUSE Labs
