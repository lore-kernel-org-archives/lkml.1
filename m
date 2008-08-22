Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbYHVU0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbYHVU0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbYHVUZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:25:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52692 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442AbYHVUZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:25:07 -0400
Date: Fri, 22 Aug 2008 12:56:27 +0200
From: Pavel Machek <pavel@suse.cz>
To: oneukum@suse.de, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       teheo@novell.com, stefanr@s5r6.in-berlin.de
Cc: Martin.Leisner@xerox.com
Subject: autosuspend for SCSI devices
Message-ID: <20080822105626.GA9475@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

Add support for autosuspend/autoresume of the SCSI devices. Lowlevel
driver can use it to spin the disk down... and it is neccessary step
for powering down the controllers.

Spinning down the disk is useful - saves ~0.5W here, and it is last
major thing we can do to save power on some small machines like
Kohjinsha subnotebooks.

Signed-off-by: Pavel Machek <pavel@suse.cz>



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
