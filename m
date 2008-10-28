Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYJ1Pub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYJ1Pub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYJ1PuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:50:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:64750 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYJ1PuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=s6WTjDMHQx194XpLdzNxlxfOjLs12DrXUrDCZ+nRHjc2K4a8n8QdVFOQ8HXCdAMyuO
         rl4mT5LsNfJUrQbKF1VEORZ4dkrgVtpwvnIKuOjCG5lwWg0ciaBU2sA6u3pCTfxtC6kh
         ExxN/G7PPp0vuscvWAG/qTERTE3J4Q1W3brSQ=
Date: Tue, 28 Oct 2008 10:49:18 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org,
       Wolfgang Beiter <w.beiter@aon.at>,
       Guenter Gebhardt <g.gebhardt@meilhaus.de>
Subject: staging: me4000 and relation to other data acquisition devices
Message-ID: <20081028154918.GA5630@mediacenter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have some questions about the user-kernel interface of the me4000
driver.  From my looking through the code it seems specific to the
me4000 hardware which does concern me since there are hundreds of
different data acquisition devices from many different vendors.  In my
opinion it would beneficial if at the very least all of these devices
shared a common device interface.

Additionally there is the out of tree Comedi project:

http://comedi.org

Which supports this hardware, and many more, with a generic device
interface.  There may be other reason not to merge Comedi (I know they
have a desire to maintain support of their RT support), but I can't help
but feel that merging the me4000 driver without thinking about the
hundreds of other devices out there is a mistake.

--
Shawn
