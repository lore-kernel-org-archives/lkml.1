Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbXDKPNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbXDKPNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXDKPNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:13:22 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:48667 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbXDKPNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:13:21 -0400
Date: Wed, 11 Apr 2007 11:12:19 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Phillip Susi <psusi@cfl.rr.com>
cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Olaf Hering <olaf@aepfle.de>, Dave Dillow <dave@thedillows.org>,
       Dave Jones <davej@redhat.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <461CF4D9.2000302@cfl.rr.com>
Message-ID: <alpine.DEB.0.83.0704111109390.13251@sigma.j-a-k-j.com>
References: <200704091007.58535.gene.heskett@gmail.com>
 <200704100353.14208.gene.heskett@gmail.com> <461BDFEA.8040602@cfl.rr.com>
 <200704110001.40573.gene.heskett@gmail.com> <461CF4D9.2000302@cfl.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I violently agree on that point, but the limited conversations I've had with
> > the tar maintainer so far indicates that AFAHIC, its linux that's broken.  A
> > new device number is a new disk and must be treated as such.
> 
> Sumbit a patch adding an option to ignore the device number, and slap him
> around a bit with a large trout ;)

I think that's especially true. If a user begins with a single full disk 
for their entire filesystem, uses tar to backup, and then later adds a 
second disk, copies everything from /usr and /home onto partitions there 
(making sure to preserve all interesting bits like ctime/mtime), and 
mounts them over the original directories, tar should not decide that 
every file in /usr and /home was deleted and recreated.
