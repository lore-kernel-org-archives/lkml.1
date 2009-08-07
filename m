Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZHGRq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZHGRq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZHGRq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:46:58 -0400
Received: from mail-bw0-f215.google.com ([209.85.218.215]:48860 "EHLO
	mail-bw0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbZHGRq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:46:57 -0400
X-Greylist: delayed 1124 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 13:46:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=pZbt8n21Z+DfzMilY9nzs2csX7rec0Gv8U+FL+/J1VZyGLvywiA/lrsCz7uPNmc7J2
         xQwNSnGweKnVhcMUmPl2bF3eXNJm4PDb3mALeH+n8yMuOk+FzY8ofiQsjgLG8PhniEKu
         K0aUfzw0hhS8ofxyGDG+O5xVM0BHU2vcGP3T4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Fri, 7 Aug 2009 19:46:07 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-00246-g90bc1a6; KDE/4.2.4; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200908071355.21648.bzolnier@gmail.com> <200908071927.36367.bzolnier@gmail.com> <20090807.103610.209136140.davem@davemloft.net>
In-Reply-To: <20090807.103610.209136140.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908071946.07991.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009 19:36:10 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Fri, 7 Aug 2009 19:27:36 +0200
> 
> > Are you trying to tell me that after 6 weeks there is still no public
> > tree to hold future IDE changes?
> > 
> > If this is indeed a case here I hope that it will get addressed ASAP.
> 
> IDE is deep maintainence, we shouldn't be doing lots of changes,
> cleanups, and things of this nature.  So urgency and timeliness
> is on a sincerely different scale for it.

Nobody is saying anything about cleanups and things of this nature..

> On the other hand, if you've been looking, I've been applying
> networking patches to net-2.6 and net-next-2.6 by the truckload
> on a daily basis because it is in active development.

Excellence in one area doesn't magically translate to other areas,
especially when said area needs a completely different approach:

I've been looking and I've seen you pushing non-trivial IDE bug-fix
patches with almost no wider hardware coverage to upstream (i.e. one
of my own patches which has been _explicitly_ marked as needing more
linux-next exposure)..
