Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYEHQT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYEHQT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYEHQTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:19:13 -0400
Received: from smtp-out-41.synserver.de ([217.119.50.41]:1141 "HELO
	smtp-out-41.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751342AbYEHQTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:19:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 19922
Date: Thu, 8 May 2008 18:18:05 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, htejun@gmail.com,
       marc.c.dionne@gmail.com, dl9pf@gmx.de, bug-track@fisher-privat.net,
       sitsofe@yahoo.com
Subject: Re: [PATCH] Re: [git patches] libata updates - (improve post-reset
	device ready test) regression
Message-ID: <20080508161805.GA3941@gentoox2.trippelsdorf.de>
References: <20080506154847.GA15299@havoc.gtf.org> <20080507145616.GA2210@gentoox2.trippelsdorf.de> <48231DAF.7070900@garzik.org> <s5hhcd83hor.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhcd83hor.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 06:05:08PM +0200, Takashi Iwai wrote:
> At Thu, 08 May 2008 11:35:11 -0400,
> Jeff Garzik wrote:
> > 
> > Markus Trippelsdorf wrote:
> > >> Tejun Heo (12):
> > >>       libata: improve post-reset device ready test
> > > 
> > > This commit (78ab88f04f44bed566d51dce0c7cbfeff6449a06) causes a long
> > > boot delay with my onboard Promise controller. It seems like libata
> > > probes for a nonexisting PATA drive...
> > > 
> > 
> > Does the attached patch fix things?
> > 
> > It basically reverts the patch, while still maintaining the 
> > consolidation.  It looks like that status evaluation is not as universal 
> > as believed.
> 
> Yes, the patch fixes the problem on my machine.
> 

Your patch fixes the problem for me, too...

-- 
Markus
