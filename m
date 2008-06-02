Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYFBK2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYFBK2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYFBK2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:28:36 -0400
Received: from styx.suse.cz ([82.119.242.94]:35637 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752650AbYFBK2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:28:35 -0400
Date: Mon, 2 Jun 2008 12:28:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Ingo Molnar <mingo@elte.hu>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
In-Reply-To: <Pine.LNX.4.64.0805292137530.13388@anakin>
Message-ID: <Pine.LNX.4.64.0806021227470.6718@jikos.suse.cz>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
 <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz> <Pine.LNX.4.64.0805292137530.13388@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Geert Uytterhoeven wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > 
> > brk: check lower bound properly
> > 
> > The check in sys_brk() on minimum value the brk might have must take 
> > CONFIG_COMPAT_BRK setting into account. When this option is turned on 
> > (i.e. we support ancient legacy binaries, e.g. libc5-linked stuff), the 
> > lower bound on brk value is mm->end_code, otherwise the brk start is 
> > allowed to be arbitrarily shifted.
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks a lot for verifying, Geert.

So, I assume the proper way to handle this now is you dropping it from 
your m68k tree, and Andrew taking it through -mm.

Thanks,

-- 
Jiri Kosina
SUSE Labs
