Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbYJXMxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbYJXMxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYJXMxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:53:14 -0400
Received: from main.gmane.org ([80.91.229.2]:44685 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbYJXMxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:53:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: w41ter@gmail.com
Subject: Re: commit a802dd0e breaks console keyboard input
Date: Fri, 24 Oct 2008 05:52:57 -0700
Organization: none
Message-ID: <alpine.LNX.2.00.0810240552320.2613@x9.ybpnyarg>
References: <49011234.7090902@gmail.com> <20081024110742.GD4620@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-183-20.dsl.irvnca.pacbell.net
In-Reply-To: <20081024110742.GD4620@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (LNX 1169 2008-08-27)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Oct 2008, Heiko Carstens wrote:

> On Thu, Oct 23, 2008 at 05:09:24PM -0700, walt wrote:
> > Hi team,
> >
> > commit a802dd0eb5fc97a50cf1abb1f788a8f6cc5db635
> > Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Date:   Mon Oct 13 23:50:08 2008 +0200
> >
> >     Call init_workqueues before pre smp initcalls.
> >
> > This commit causes the console login prompt to ignore my keystrokes
> > so I'm unable to log in (though ssh works fine).  Oddly, if I hit
> > ctrl-alt-delete the machine does reboot, but no other keystrokes
> > appear on the screen or have any effect that I can detect.
> >
> > No surprise that this problem appears only on my dual-core amd64
> > machine, while the k7 single processor machine works normally.
> >
> > I've not seen anyone else complaining on the linux list, so maybe
> > this is a BIOS bug on the affected machine?  It's an ECS mobo with
> > a GeForce6100PM-M2 chipset, and I use a ps/2 keyboard.
>
> Could you try the patch below and see if it makes any difference?
> Thanks!

<patch snipped for brevity>

No difference that I can detect, sorry.  The login prompt still
ignores my keystrokes.  I'm happy to try any other ideas or patches.
(Yes, I did use git bisect to find this commit.)

Thanks.


