Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZIONBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZIONBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIONBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:01:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZIONBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:01:47 -0400
Date: Tue, 15 Sep 2009 15:01:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [1/5] kbuild: Fix ld-option Makefile macro to really
	work
Message-ID: <20090915130146.GA12351@basil.fritz.box>
References: <200909141018.915641783@firstfloor.org> <20090914201806.EE6A0B1757@basil.firstfloor.org> <20090914214711.GB7990@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914214711.GB7990@merkur.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So now we pass the option direct to the linker rather than via gcc -wl.
> I assume this breaks the other 8 uses of ld-option in the kernel?
> 
> Or does ld understand the -wl,... syntax?

It does not. But -X is passed directly to the linker, not via gcc,
so it needs to probe ld directly

The right fix is probably an new macro that works with ld (and
ideally rename this one which is confusingly named) I'll
send an updated patch.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
