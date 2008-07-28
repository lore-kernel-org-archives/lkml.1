Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbYG1SYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbYG1SYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYG1SYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:24:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYG1SYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:24:38 -0400
Date: Mon, 28 Jul 2008 15:24:21 -0300
From: Glauber Costa <gcosta@redhat.com>
To: Andrew Drake <drakedevel.lists@gmail.com>
Cc: Andrew Drake <zappacky.lists@gmail.com>, Glauber Costa <glommer@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bisected] Regression: Hang on boot in
	schedule_timeout_interruptible during ACPI init on SMP
Message-ID: <20080728182420.GB3697@redhat.com>
References: <4887B4D5.1050306@gmail.com> <5d6222a80807231731u41f9fb81w2796b3db1a5920e6@mail.gmail.com> <488B7297.8090405@gmail.com> <20080728141533.GA3697@redhat.com> <2ae234c70807280946s77a02e1ex120fc2723e286a9e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ae234c70807280946s77a02e1ex120fc2723e286a9e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 12:46:09PM -0400, Andrew Drake wrote:
> On Mon, Jul 28, 2008 at 10:15 AM, Glauber Costa <gcosta@redhat.com> wrote:
> > fine, but if you can still help us on this, it would be awesome ;-)
> >
> 
> Oh absolutely! :P I'm not the type to settle on a workaround.
> 
> > Actually, there is another nasty bug that depends, at least by a first
> > impression, on the lapic timer. I'm planning to save a time today to
> > look further on your problem.
> 
> Thanks!
> 
> >
> > Probably because the order of initialization of smp entities changed a
> > bit during this series. Probably the lapic timer is now initialized a
> > little bit earlier, before we have the chance to mark it as bad.
> >
> 
> I noticed that; but I couldn't find where it was indeed marked as bad.
FYI: Bug 11101 (http://bugzilla.kernel.org/show_bug.cgi?id=11101) is probably
the same bug as yours. I've just updated a possible solution in there.
Could you verify that?

Thanks!

> 
> > If you can send me at least your dmesgs and cpuinfo, it would be really really
> > awesome.
> >
> 
> Did you get my most recent email? (It was sent to your glommer[at]
> address, and CC'd to the kernel list) If you didn't receive it, I'll
> forward you the message. It included dmesg of good kernel, dmesg of
> bad kernel, cpuinfo, .config, and my disassembled DSDT (which, as a
> side project, I'm doing a full-blown reverse engineering of).
> 
> Thanks,
> 
> Andrew
> 
> P.S. I apologize in advance if this email is HTML, I'm at work and I
> have to use the gmail web interface, I have it set to "text only", but
> you never know.
