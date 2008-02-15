Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYBOFAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYBOFAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbYBOFAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:00:17 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2864 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYBOFAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:00:14 -0500
Subject: Re: [PATCH] ubi: fix sparse errors in ubi.h
From: Joe Perches <joe@perches.com>
To: Ben Dooks <ben@fluff.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080214235637.GA4715@fluff.org.uk>
References: <1203025995.5601.0.camel@brick>
	 <20080214235637.GA4715@fluff.org.uk>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 20:58:31 -0800
Message-Id: <1203051511.13820.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 23:56 +0000, Ben Dooks wrote:
> On Thu, Feb 14, 2008 at 01:53:15PM -0800, Harvey Harrison wrote:
> > In C, signed 1-bit bitfields can only take the values 0 and -1, only
> > 0 and 1 are ever assigned in current code.  Make them unsigned
> > bitfields.
> > 
> > Fixes the (repeated) sparse errors:
> > drivers/mtd/ubi/ubi.h:220:15: error: dubious one-bit signed bitfield
> > drivers/mtd/ubi/ubi.h:221:17: error: dubious one-bit signed bitfield
> > drivers/mtd/ubi/ubi.h:222:18: error: dubious one-bit signed bitfield
> > drivers/mtd/ubi/ubi.h:223:16: error: dubious one-bit signed bitfield
> > drivers/mtd/ubi/ubi.h:224:20: error: dubious one-bit signed bitfield
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > Sorry, not sure who to CC on this.
> 
> IIRC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

UNSORTED BLOCK IMAGES (UBI)
P:      Artem Bityutskiy
M:      dedekind@infradead.org
W:      http://www.linux-mtd.infradead.org/
L:      linux-mtd@lists.infradead.org
T:      git git://git.infradead.org/~dedekind/ubi-2.6.git
S:      Maintained
F:      drivers/mtd/ubi
F:      include/linux/mtd/ubi.h
F:      include/mtd/ubi-*


