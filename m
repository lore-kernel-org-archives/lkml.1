Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbXEIVtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbXEIVtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXEIVsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:48:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53203 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbXEIVsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:48:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46424198.1090808@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 23:48:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 5/6] firewire: SBP-2 highlevel driver
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <20070502194408.GD1248@infradead.org> <464237A9.6060301@redhat.com>
In-Reply-To: <464237A9.6060301@redhat.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> Isn't max_sectors the overall size limit of the request, though?

BTW, mainline sbp2 sets max_sectors=512 per default because one 1st
generation bridge needed it.  fw-sbp2 lets the SCSI stack chose the
default max_sectors, which is SCSI_DEFAULT_MAX_SECTORS i.e. 1024.
I think that should be fine with practically all SBP-2 bridges in
use today, but max_sectors > 512 was never widely tested.
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/
