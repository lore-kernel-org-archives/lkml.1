Return-Path: <linux-kernel-owner+w=401wt.eu-S1764387AbZDHTOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764387AbZDHTOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZDHTOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:14:01 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44085 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbZDHTOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:14:00 -0400
Date: Wed, 8 Apr 2009 13:13:59 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: Prepare for hard drives w/ non-512 sector sizes
Message-ID: <20090408191359.GM20983@parisc-linux.org>
References: <20090408065955.GA29845@havoc.gtf.org> <20090408183243.GK20983@parisc-linux.org> <49DCF14F.1060407@garzik.org> <20090408185639.GL20983@parisc-linux.org> <49DCF61E.2000703@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DCF61E.2000703@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 03:08:14PM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >?!  Are you referring to the one incident where you asked me if I had
> >any patches for 2.6.30, I pointed at the TRIM patches and you quibbled
> >that I hadn't reposted the updates, only a git tree?
> 
> On multiple occasions.  You're the only one I have to poke to get 
> updates on pending libata patches, in some cases, patches that really 
> should have gone upstream long ago.

I send patches and get no feedback from the maintainer (you).  So I
work on other things instead.  The 4k sector size support is largely
theoretical anyway, given that every _SATA_ vendor I've heard from is
planning on doing 4k physical / 512 byte logical sectors.  SAS is a
different matter, but is irrelevant to this series of patches.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
