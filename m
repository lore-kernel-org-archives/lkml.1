Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZDWGlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZDWGlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZDWGl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:41:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbZDWGl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:41:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: ptracee data structures cleanup
In-Reply-To: Mike Frysinger's message of  Wednesday, 22 April 2009 19:01:51 -0400 <8bd0f97a0904221601t110b0dd4xfe1f957de0e3fff7@mail.gmail.com>
References: <20090330185146.D525AFC3AB@magilla.sf.frob.com>
	<20090408203954.GA26816@redhat.com>
	<20090416204004.GA28013@redhat.com>
	<20090416232430.4DAE4FC3C6@magilla.sf.frob.com>
	<20090420183718.GC32527@redhat.com>
	<20090421011354.4B19EFC3C7@magilla.sf.frob.com>
	<20090421214819.GA22845@redhat.com>
	<20090422032205.B8D39FC3C7@magilla.sf.frob.com>
	<20090422220400.GA22755@redhat.com>
	<8bd0f97a0904221601t110b0dd4xfe1f957de0e3fff7@mail.gmail.com>
X-Zippy-Says: I'm also against BODY-SURFING!!
Message-Id: <20090423064122.99BC3FC3C7@magilla.sf.frob.com>
Date: Wed, 22 Apr 2009 23:41:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Blackfin was based on m68knommu, so it is most likely unused by us.
> the only ptrace consumers are gdb(server) and strace and neither use
> it afaik.

These are not user-visible bits, just implementation cruft in the kernel.
If no arch code in the kernel really does anything with the bit, that is
all there is to it.


Thanks,
Roland
