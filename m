Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYGOXrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYGOXrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYGOXrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:47:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49579 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbYGOXrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:47:04 -0400
Message-ID: <487D36D9.6020105@garzik.org>
Date: Tue, 15 Jul 2008 19:46:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org> <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org> <487CF29E.5000009@garzik.org> <alpine.LFD.1.10.0807151159400.3351@woody.linux-foundation.org> <487D01B5.7020300@garzik.org> <alpine.LFD.1.10.0807151310370.2867@woody.linux-foundation.org> <487D0ED1.7010003@garzik.org> <20080715230204.GC10532@redhat.com>
In-Reply-To: <20080715230204.GC10532@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Tue, Jul 15, 2008 at 04:55:45PM -0400, Jeff Garzik wrote:
> 
>  > No, I spelled out a list of projects, what would break, and how it would 
>  > break.
>  > 
>  > Again,
>  > 
>  > * Red Hat driver disks.  The build process is unaware of the need to 
>  > bundle firmware.  Any use with Fedora (or, later, RHEL) will result in a 
>  > non-working driver, for the simple reason that firmware is not copied 
>  > onto the image.
> 
> For old RHEL - they won't support 2.6.27, so moot.
> For next-gen RHEL - they need fixing anyway.
> For Fedora, they don't (and hopefully won't) exist.

Grin,
http://docs.fedoraproject.org/fedora-install-guide-en/fc5/sn-bootoptions-hardware.html

Or DKMS, which should package firmware:
http://linux.dell.com/projects.shtml

