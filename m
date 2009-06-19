Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZFSUTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZFSUTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZFSUTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:19:02 -0400
Received: from torrent.CC.McGill.CA ([132.206.27.49]:42693 "EHLO
	torrent.cc.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZFSUTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:19:02 -0400
Subject: Re: Panic booting 2.6.30
From: David Ronis <ronis@ronispc.chem.mcgill.ca>
Reply-To: ronis@ronispc.chem.mcgill.ca
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4A3BE7EA.4050800@msgid.tls.msk.ru>
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
	 <4A3BE7EA.4050800@msgid.tls.msk.ru>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Department of Chemistry, McGill University
Date: Fri, 19 Jun 2009 16:19:02 -0400
Message-Id: <1245442742.25076.9.camel@ronispc.chem.mcgill.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2009.6.15.190422
X-McGill-WhereFrom: Internal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply.  I added large-memory to lilo.conf, reran lilo,
and rebooted.  I get the same problem, except now the unknown-block was
3,2. when I boot without specifying root=hda2, with root=hda2 I get the
same behavior.

David

On Fri, 2009-06-19 at 23:32 +0400, Michael Tokarev wrote:
> David Ronis wrote:
> > I've just upgraded an older machine (a P3 running slackware 11.0) from
> > 2.6.26.5 to 2.6.30; the build was uneventful.  However, on reboot (using
> > lilo) I get:
> > 
> > VSF:  Cannot open root device "hda2" or unknown-block(0,0)
> > Please append a correct root= boot option; here are the available
> > partions:     <====== nothing shows here...
> > Kernel-Panic - not syncing.
> > 
> > I had rebooted with and without root=hda2.   The old kernel is still
> > usable.
> > 
> > Lilo.conf looks like:
> 
> Add large-memory option to lilo.conf
> 
> /mjt
> 
