Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYHVHmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYHVHmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYHVHma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:42:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33658 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbYHVHm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:42:29 -0400
Date: Fri, 22 Aug 2008 09:42:28 +0200
From: Pavel Machek <pavel@suse.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       marcel@holtmann.org, maxk@qualcomm.com
Subject: Re: 2.6.17-rc3: hci-usb related warnings and error on resume
Message-ID: <20080822074228.GA27650@atrey.karlin.mff.cuni.cz>
References: <200808202055.46558.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808202055.46558.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I recently got a new laptop (HP 2510p) and have been playing with 
> suspend/resume. Initially the dmesg after resume was fairly clean, but 
> that was with the bluetooth device disabled (I initially disabled it in 
> Windows).

avoid hci_usb. It is racy as hell. btusb actually works.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
