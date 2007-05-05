Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbXEEHgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbXEEHgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 03:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXEEHgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 03:36:36 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:48554 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754082AbXEEHgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 03:36:35 -0400
Date: Sat, 5 May 2007 09:36:32 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Jon Burgess <jburgess777@googlemail.com>, linux-dvb@linuxtv.org,
       v4l-dvb-maintainer@linuxtv.org,
       Markus Rechberger <mrechberger@gmail.com>, linux-kernel@vger.kernel.org,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [PATCH] Re: More than 2Gb problem (dvb related) ?
Message-ID: <20070505073632.GA6726@gmail.com>
References: <20070427111047.GB10284@gmail.com> <20070501094153.GC6895@gmail.com> <1178057515.25218.24.camel@localhost.localdomain> <200705021135.32835.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705021135.32835.ak@suse.de>
X-Operating-System: Linux 2.6.21.1
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:35:32AM +0200, Andi Kleen wrote:
> 
> > Looks like you hit:
> > 	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK | __GFP_NO_GROW));
> > 
> > I guess this was due to the vmalloc_32() change now passing in
> > GFP_DMA32. Looks like that could be a problem with the
> > x86_64-mm-vmalloc-32 patch. Andi?
> 
> Does this patch help?

Hello,

now I am quiete certain the bug is gone with that patch : no single
error since Wed :-)

I hope they goes in 2.6.21.2.

Have a great week,
-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
