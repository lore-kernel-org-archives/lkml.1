Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYGGGgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYGGGgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYGGGfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:35:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbYGGGfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:35:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: benh@kernel.crashing.org
X-Fcc: ~/Mail/linus
Cc: Nathan Lynch <ntl@pobox.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
In-Reply-To: Benjamin Herrenschmidt's message of  Monday, 7 July 2008 16:23:20 +1000 <1215411800.8970.91.camel@pasglop>
References: <20080703234140.GC9594@localdomain>
	<20080704021929.5E9EF1541F5@magilla.localdomain>
	<1215409693.8970.79.camel@pasglop>
	<20080707061811.19989154246@magilla.localdomain>
	<1215411800.8970.91.camel@pasglop>
X-Windows: it was hard to write; it should be hard to use.
Message-Id: <20080707063522.5FE55154246@magilla.localdomain>
Date: Sun,  6 Jul 2008 23:35:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure... if ld.conf.d isn't parse of the kernel source tree then
> it -will- end in tears...

Of course, you should include the file you want people to install
as part of the kernel source or build.  You can copy it into
place in make install or something if you like (convention is to
call it something.conf in /etc/ld.so.conf.d); then run ldconfig.
The x86-xen case has not bothered to include its one-line file as
such, just the comment in arch/x86/vdso/vdso32/note.S telling you
what it is.


Thanks,
Roland
