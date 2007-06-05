Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbXFEOwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbXFEOwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbXFEOv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:51:59 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:33437 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbXFEOv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:51:58 -0400
Date: Tue, 5 Jun 2007 10:51:54 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@redhat.com>, Gregor Jasny <gjasny@googlemail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       Ingo Molnar <mingo@elte.hu>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Simon <sg02r@ecs.soton.ac.uk>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [4/5] 2.6.22-rc4: known regressions
In-Reply-To: <466576B1.5020105@googlemail.com>
Message-ID: <Line.LNX.4.64.0706051049050.21439@d.namei>
References: <46657407.1000108@googlemail.com> <466576B1.5020105@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Michal Piotrowski wrote:

> SELinux
> 
> Subject    : very high non-preempt latency in context_struct_compute_av()
> References : http://lkml.org/lkml/2007/6/4/78
> Submitter  : Ingo Molnar <mingo@elte.hu>
> Handled-By : Stephen Smalley <sds@tycho.nsa.gov>
>             James Morris <jmorris@namei.org>
> Status     : unknown

Not sure what the criteria are for being listed as a regression, but this 
problem was likely introduced many moons ago with changes which reduced 
the memory footprint of security policy.


-- 
James Morris
<jmorris@namei.org>
