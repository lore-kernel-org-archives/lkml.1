Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbZDHRK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbZDHRK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZDHRKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:10:04 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1196 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbZDHRKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:10:03 -0400
Subject: Re: [PATCH 02/10] MAINTAINERS - Add file patterns
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090408165110.GA32400@kroah.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <1239167872-8179-3-git-send-email-joe@perches.com>
	 <20090408165110.GA32400@kroah.com>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 10:07:55 -0700
Message-Id: <1239210475.32726.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 09:51 -0700, Greg KH wrote:
> On Tue, Apr 07, 2009 at 10:17:44PM -0700, Joe Perches wrote:
> >  DRIVER CORE, KOBJECTS, AND SYSFS
> >  P:	Greg Kroah-Hartman
> >  M:	gregkh@suse.de
> >  L:	linux-kernel@vger.kernel.org
> >  T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> >  S:	Supported
> > +F:	Documentation/kobject.txt
> > +F:	drivers/base/core.c
> 
> That should be drivers/base*

OK.  You'll also get changes in drivers/base/power/
Here it is now...

commit 8239947be909d5aba4e9fa809bbabcedd2653847
Author: Joe Perches <joe@perches.com>
Date:   Wed Apr 8 10:04:18 2009 -0700

    MAINTAINERS - Update DRIVER CORE patterns
    
    Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b663cea..2827fc1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1817,17 +1817,17 @@ F:	drivers/scsi/dpt/
 
 DRIVER CORE, KOBJECTS, AND SYSFS
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
 F:	Documentation/kobject.txt
-F:	drivers/base/core.c
+F:	drivers/base/
 F:	fs/sysfs/
 F:	include/linux/kobj*
 F:	lib/kobj*
 
 DRM DRIVERS
 P:	David Airlie
 M:	airlied@linux.ie
 L:	dri-devel@lists.sourceforge.net


