Return-Path: <linux-kernel-owner+w=401wt.eu-S932885AbXHaPam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbXHaPam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXHaPae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:30:34 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33624 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755854AbXHaPad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:30:33 -0400
X-Sasl-enc: Y8jLcdtnx3id5opO/ZIRQGJNHd2KMv8SsLxoEw3uDYF9 1188574231
Subject: Re: NFS hang + umount -f: better behaviour requested.
From: Ian Kent <raven@themaw.net>
To: Valdis.Kletnieks@vt.edu
Cc: John Stoffel <john@stoffel.org>, Peter Staubach <staubach@redhat.com>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <27240.1188573002@turing-police.cc.vt.edu>
References: <20070820225415.GL3956@digitalkingdom.org>
	 <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com>
	 <18123.13314.43009.263383@stoffel.org>
	 <Pine.LNX.4.64.0708311600120.12745@raven.themaw.net>
	 <27240.1188573002@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 23:30:25 +0800
Message-Id: <1188574226.3086.0.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 11:10 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 31 Aug 2007 16:06:36 +0800, Ian Kent said:
> > So, there's a power outage and the UPS had a glitch.
> 
> Murphy can get a *lot* more creative than that.
> 
> So we'd outgrown the capacity on our UPS and diesel generator, and decided
> to replace them.  So we schedule downtime for a Saturday.  Rather scary, we
> had a Sun E10K that had been powered-up for several years, and just as expected,
> a good fraction of the 400+ drives it had failed to re-spinup.  While recovering
> from that, we discovered that although the vast majority of the 400 drives were
> either mirrors or raidsets, due to a config error, the boot volume wasn't
> mirrored (fortunately, it spun up OK so we dodged the bullet), so we fixed that.
> 
> Literally the next Friday, not even a week later, a contractor relocating a
> door into our machine room shorted out a sensor circuit in our fire suppression
> system, triggering a Halon dump.  Of course, no amount of UPS and diesel was
> going to save us now, because there was a safety interlock that killed the
> power feeds if the Halon dumped.  This time, since they'd all been stressed
> just a week before, only 2 of the 400+ disks on the E10K failed to spin up.
> 
> Guess which two. ;)

Eeeeeekkkk!!
The mirrors, of course.

Ian


