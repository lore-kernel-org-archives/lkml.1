Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZBDJ4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZBDJ4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZBDJz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:55:56 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:57763 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750866AbZBDJz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:55:56 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 04:55:55 EST
Date: Wed, 4 Feb 2009 10:49:13 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <error27@gmail.com>, R.E.Wolff@BitWizard.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] unlock_kernel() on error path in sx_fw_ioctl()
Message-ID: <20090204094913.GB23618@bitwizard.nl>
References: <alpine.DEB.2.00.0902030829580.31813@bikeee> <20090203205857.a2b4b1c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203205857.a2b4b1c1.akpm@linux-foundation.org>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 08:58:57PM -0800, Andrew Morton wrote:
> fix another such path - missed func_exit().

This is not critical. It's just debug. When DEBUG_CALLS (or something
like that) is active, it will print "leaving function ... ". 

Indeed if it's missing, you might start to think why DID it return,
but not print the message... or. howcome it's still in that function
doing stuff that isn't there. Anyway, looking into it would provide
you more info that it was returning the error.....

Anyway, nice to clean it up "while we're at it". 

	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
