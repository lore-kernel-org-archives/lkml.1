Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYEHTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYEHTWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYEHTVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:21:55 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58978 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYEHTVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:21:53 -0400
Date: Thu, 8 May 2008 20:21:12 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeff Garzik <jeff@garzik.org>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>, Takashi Iwai <tiwai@suse.de>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, htejun@gmail.com,
       marc.c.dionne@gmail.com, dl9pf@gmx.de, bug-track@fisher-privat.net,
       sitsofe@yahoo.com
Subject: Re: [PATCH] Re: [git patches] libata updates - (improve post-reset
 device ready test) regression
In-Reply-To: <20080508161805.GA3941@gentoox2.trippelsdorf.de>
Message-ID: <Pine.LNX.4.64.0805082014570.22950@blonde.site>
References: <20080506154847.GA15299@havoc.gtf.org> <20080507145616.GA2210@gentoox2.trippelsdorf.de>
 <48231DAF.7070900@garzik.org> <s5hhcd83hor.wl%tiwai@suse.de>
 <20080508161805.GA3941@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Markus Trippelsdorf wrote:
> On Thu, May 08, 2008 at 06:05:08PM +0200, Takashi Iwai wrote:
> > At Thu, 08 May 2008 11:35:11 -0400,
> > Jeff Garzik wrote:
> > > 
> > > It basically reverts the patch, while still maintaining the 
> > > consolidation.  It looks like that status evaluation is not as universal 
> > > as believed.
> > 
> > Yes, the patch fixes the problem on my machine.
> 
> Your patch fixes the problem for me, too...

And for me: I was preparing to report when I saw these go by.
A Fujitsu-Siemens laptop and a Fujitsu-Siemens desktop were each taking
70 seconds longer to boot than before.  (The status byte was 0x7f.)

Thanks,
Hugh
