Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZGOI23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZGOI23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 04:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZGOI23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 04:28:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41426 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752645AbZGOI22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 04:28:28 -0400
Date: Wed, 15 Jul 2009 09:28:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
       Jaroslav Kysela <erex@perex.cz>, alsa-devel@alsa-project.org,
       Takashi Iwai <iwai@suse.de>, Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/06] Fix compilation warning for
 sound/soc/codecs/wm8400.c
Message-ID: <20090715082826.GA8689@rakim.wolfsonmicro.main>
References: <20090715021826.4032.63752.sendpatchset@subratamodak.linux.ibm.com>
 <1247633018.2437.5.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247633018.2437.5.camel@ht.satnam>
X-Cookie: Use other side for additional listings.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 10:13:38AM +0530, Jaswinder Singh Rajput wrote:
> Hello Subrata,

> This kind of warnings born due to not handling the variables properly.
> Please try to understand the root cause of this warning, just shutting
> this warning is of no use.

...as I said last time you submitted rougly the same patch.  Please also
remember that sometimes these problems are false positives caused by
issues with the compiler flow analysis (as appears to be the case here).
