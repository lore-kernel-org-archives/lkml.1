Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbYKETum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbYKETum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbYKETsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:48:40 -0500
Received: from ns.suse.de ([195.135.220.2]:52679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965AbYKETsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:48:39 -0500
From: Andreas Schwab <schwab@suse.de>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Always include <linux/types.h>
References: <491073BB.4000900@panasas.com>
	<1225817069-5969-1-git-send-email-bharrosh@panasas.com>
	<20081104180347.GA9818@uranus.ravnborg.org>
	<20081105163941.GB6561@logfs.org>
	<20081105172312.GA10585@x200.localdomain>
	<20081105191628.GC6561@logfs.org>
X-Yow: All right, you degenerates!  I want this place evacuated in 20 seconds!
Date: Wed, 05 Nov 2008 20:48:36 +0100
In-Reply-To: <20081105191628.GC6561@logfs.org> (=?iso-8859-1?Q?=22J=F6rn?=
 Engel"'s message of
	"Wed, 5 Nov 2008 20:16:29 +0100")
Message-ID: <je7i7ilzsb.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:

> My hope was actually to speed up compilation.  If the average c file
> includes 10 headers, on types.h will get included by most of them,
> possibly multiple times.  Each run after the first still has to parse
> the whole file, just to drop everything between  #ifndef _LINUX_TYPES_H
> and #endif.

Actually GCC is smart enought to note the bracketing and avoid even
looking at it a second time.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
