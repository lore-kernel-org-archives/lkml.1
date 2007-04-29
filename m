Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXD2OH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXD2OH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 10:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933238AbXD2OH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 10:07:58 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:56174 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933235AbXD2OH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 10:07:57 -0400
Date: Sun, 29 Apr 2007 16:07:53 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: Jon Burgess <jburgess777@googlemail.com>
Cc: linux-dvb@linuxtv.org, v4l-dvb-maintainer@linuxtv.org,
       Markus Rechberger <mrechberger@gmail.com>, linux-kernel@vger.kernel.org,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [PATCH] Re: More than 2Gb problem (dvb related) ?
Message-ID: <20070429140753.GA6677@gmail.com>
References: <20070427111047.GB10284@gmail.com> <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com> <1177711220.26292.20.camel@localhost.localdomain> <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com> <1177780652.7152.14.camel@localhost.localdomain> <1177791277.5170.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1177791277.5170.11.camel@localhost.localdomain>
X-Operating-System: Linux 2.6.21.1
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 09:14:37PM +0100, Jon Burgess wrote:

> While the above patch works, it seems the underlying causes is that
> vmalloc_32() is providing memory above 4Gb on x86-64 which is not what
> the driver expects. This same issue came up a few weeks ago with regards
> to DRM on radeon http://lkml.org/lkml/2007/4/1/257
> 
> Andi Kleen included a patch to ensure vmalloc_32() returns memory <4Gb
> in a patch which is currently in -mm
>  http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/x86_64-mm-vmalloc-32.patch
> 
> With this patch applied the current driver appears to work OK. 
> 
> Attached is a smaller patch against v4l-dvb which just adds the missing
> pci_unmap_sg() call.
> 
> 	Jon
> 
> Signed-off-by: Jon Burgess <jburgess777@googlemail.com>

Tremendous : after a perfect weekend for paragliding a solution appear
here :-)

I hope both patch will be included very soon ;-)

And it's works perfectly, thank you very much,
-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
