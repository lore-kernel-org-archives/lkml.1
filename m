Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYHCP5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYHCP5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbYHCP5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:57:43 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60775 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756243AbYHCP5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:57:42 -0400
Subject: Kernel Summit request for Discussion of future of ATA (libata) and
	IDE
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 10:57:35 -0500
Message-Id: <1217779055.4179.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right at the moment, we have two separate subsystems for running IDE
type devices:  driver/ide and drivers/ata.  The claim I've seen is that
drivers/ata can do everything drivers/ide can do plus it does sata.  I
also note that no major distribution seems to enable anything in
drivers/ide anymore, so given this is it time to deprecate drivers/ide?

A counter argument to the above is that not all drivers (particularly
the older ones where hw is scarce) are converted to drivers/ata, so
drivers/ide seems to be needed for some legacy systems (in which case it
can be deprecated but not removed).  I've also noted that some embedded
distributions seem to be using drivers/ide, but I'm not really sure
whether this is inertia or some overriding need.

The proposal is to discuss the future of these two subsystems and arrive
at a consensus what's happening to each going forwards.

James


