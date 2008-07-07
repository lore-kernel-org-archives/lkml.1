Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYGGGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYGGGtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYGGGtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:49:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:45095 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYGGGtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:49:09 -0400
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roland McGrath <roland@redhat.com>
Cc: Nathan Lynch <ntl@pobox.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080707063522.5FE55154246@magilla.localdomain>
References: <20080703234140.GC9594@localdomain>
	 <20080704021929.5E9EF1541F5@magilla.localdomain>
	 <1215409693.8970.79.camel@pasglop>
	 <20080707061811.19989154246@magilla.localdomain>
	 <1215411800.8970.91.camel@pasglop>
	 <20080707063522.5FE55154246@magilla.localdomain>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 16:48:47 +1000
Message-Id: <1215413327.8970.108.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 23:35 -0700, Roland McGrath wrote:
> > I'm not sure... if ld.conf.d isn't parse of the kernel source tree then
> > it -will- end in tears...
> 
> Of course, you should include the file you want people to install
> as part of the kernel source or build.  You can copy it into
> place in make install or something if you like (convention is to
> call it something.conf in /etc/ld.so.conf.d); then run ldconfig.
> The x86-xen case has not bothered to include its one-line file as
> such, just the comment in arch/x86/vdso/vdso32/note.S telling you
> what it is.

Nathan, can you discuss that with Steve Munroe and see if he's ok
with such an approach ?

Cheers,
Ben.


