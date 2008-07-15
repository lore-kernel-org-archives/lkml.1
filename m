Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYGOXJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYGOXJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYGOXJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:09:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbYGOXJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:09:09 -0400
Date: Tue, 15 Jul 2008 19:02:04 -0400
From: Dave Jones <davej@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080715230204.GC10532@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Frans Pop <elendil@planet.nl>, arjan@infradead.org,
	akpm@linux-foundation.org, dwmw2@infradead.org,
	alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org> <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org> <487CF29E.5000009@garzik.org> <alpine.LFD.1.10.0807151159400.3351@woody.linux-foundation.org> <487D01B5.7020300@garzik.org> <alpine.LFD.1.10.0807151310370.2867@woody.linux-foundation.org> <487D0ED1.7010003@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D0ED1.7010003@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 04:55:45PM -0400, Jeff Garzik wrote:

 > No, I spelled out a list of projects, what would break, and how it would 
 > break.
 > 
 > Again,
 > 
 > * Red Hat driver disks.  The build process is unaware of the need to 
 > bundle firmware.  Any use with Fedora (or, later, RHEL) will result in a 
 > non-working driver, for the simple reason that firmware is not copied 
 > onto the image.

For old RHEL - they won't support 2.6.27, so moot.
For next-gen RHEL - they need fixing anyway.
For Fedora, they don't (and hopefully won't) exist.

	Dave

-- 
http://www.codemonkey.org.uk
