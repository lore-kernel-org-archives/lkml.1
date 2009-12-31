Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZLaTYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZLaTYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 14:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZLaTYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 14:24:15 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34930 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbZLaTYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 14:24:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qHOborzAg+HI9YgCimg5iFYt7Zr45Lu2Fuk7P4GMirSoFROTqTG5pqUvqU80mDD0Lb
         M3vIk3LWfJDzpjKw02/XQCO8T8BXA+xuM9E8JqQ1lgVy2PJFUUcpgmLN5oDMMD5f3aZE
         wJsHgedxF0EHzLhdJhcL6r3UsB9oMnjtzD37o=
MIME-Version: 1.0
In-Reply-To: <20091231110747.5efc1efa.randy.dunlap@oracle.com>
References: <20091231112314.a51e160b.sfr@canb.auug.org.au>
	 <20091231110747.5efc1efa.randy.dunlap@oracle.com>
Date: Thu, 31 Dec 2009 11:20:02 -0800
Message-ID: <12c511ca0912311120i3f60fccas3487c1f47b5cf3c3@mail.gmail.com>
Subject: Re: linux-next: Tree for December 31 (kgdb)
From: Tony Luck <tony.luck@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, jbarnes@virtuousgeek.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jason Wessel <jason.wessel@windriver.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb bits break ia64 (and any other architecture without an
<asm/kgdb.h> too):

In file included from include/drm/drm_fb_helper.h:33,
                 from include/drm/drm_crtc_helper.h:42,
                 from drivers/gpu/drm/radeon/radeon_device.c:30:
include/linux/kgdb.h:21:22: error: asm/kgdb.h: No such file or directory
In file included from include/drm/drm_fb_helper.h:33,
                 from include/drm/drm_crtc_helper.h:42,
                 from drivers/gpu/drm/radeon/radeon_device.c:30:
include/linux/kgdb.h:86: error: 'BREAK_INSTR_SIZE' undeclared here
(not in a function)


Perhaps it is time for me to dust off the partially working kgdb
patches that I had a
year ago.

-Tony
