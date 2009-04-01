Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbZDAXqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbZDAXqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZDAXql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:46:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37874 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZDAXqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:46:40 -0400
Date: Thu, 2 Apr 2009 00:44:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Dave Chinner <david@fromorbit.com>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090401234444.GA20301@srcf.ucam.org>
References: <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <1238417751.30488.12.camel@think.oraclecorp.com> <20090331235509.GU26138@disturbed> <1238590413.18549.7.camel@think.oraclecorp.com> <49D38B22.1050105@ursus.ath.cx> <1238601746.18549.55.camel@think.oraclecorp.com> <20090401215040.GA7350@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401215040.GA7350@mit.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 05:50:40PM -0400, Theodore Tso wrote:
> On Wed, Apr 01, 2009 at 12:02:26PM -0400, Chris Mason wrote:
> > 
> > If we crash during the rsync, the backup logs will yell.  If we crash
> > just after the rsync, the backup logs won't know.  The data could still
> > be gone.
> 
> So have rsync call the sync() system call before it exits.

sync() isn't guaranteed to be synchronous. Treating it as such isn't 
portable.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
