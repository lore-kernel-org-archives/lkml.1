Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbXE1JLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbXE1JLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXE1JLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:11:35 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:48752 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751866AbXE1JLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:11:34 -0400
Date: Mon, 28 May 2007 11:11:18 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
Cc: ak@suse.de
Subject: Re: BUG : 2.6.21.1 -> 2.6.21.3 breaks cx88 (4 Gb)
Message-ID: <20070528091118.GA12886@gmail.com>
References: <20070527065202.GA6908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070527065202.GA6908@gmail.com>
X-Operating-System: Linux 2.6.21.1
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 08:52:02AM +0200, Gregoire Favre wrote:

Oops,

i was wrong : I did patch my 2.6.21.1 with x86_64-mm-vmalloc-32.patch :

Fix vmalloc_32 to really allocate <4GB on 64bit platforms

Ugly ifdef, but should handle all 64bit platforms that have suitable
zones. On some like Altix it's probably impossible without IOMMU
use to get memory <4GB this way,  but they have to live with that.
Signed-off-by: Andi Kleen <ak@suse.de>

And I don't remember exactly what else (in case that needed I could look
at my email archive) but the bug that was found in 2.6.21 regarding the
use of system with 4Gb is still present in 2.6.21.3 : is that something
that was forgotten to be included ?

Please CC to me all lkml answer as I am not on lkml, thank.

> Hello,
> 
> I thought my budget Geniatech DVB-S was out of order, because there was
> high lightning, but it's not the case.
> 
> Under 2.6.21.1 with included dvb driver and with hg drivers (a little
> bit outdated) my budget-av and my cx88 card works just great.
> 
> Under 2.6.21.3 with included dvb driver and with hg drivers (up to date
> from yesterday) my budget-av works just great, but the cx88 can only
> tune but don't deliver anything ???
> 
> In case that matter I am under 64 bits (Core 2 Duo).
> 
> Anyone got an idea what might cause this ?
> -- 
> Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
>                http://picasaweb.google.com/Gregoire.Favre

-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
