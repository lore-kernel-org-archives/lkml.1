Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbYAPJyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbYAPJyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYAPJyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:54:08 -0500
Received: from dtp.xs4all.nl ([80.126.206.180]:17203 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751785AbYAPJyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:54:07 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2008 04:54:06 EST
Date: Wed, 16 Jan 2008 10:46:40 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: mtime updates for mmapped files. 
Message-ID: <20080116094640.GA2071@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I  wrote a small app yesterday that updates a file by mmapping the 
file (RW), changing the thing around, and then exiting. 

This did not trigger a change in the mtime of the file. Thus rsync
didn't pick up that the file had changed.

I understand that tracking every change to a RW mmapped file is
costly, and thus unfeasable, but shouldn't then the close cause a
mtime update?

The server where this happened is running 2.6.21, so my apologies if
this has already been corrected.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
