Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYCTLPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYCTLPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 07:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYCTLPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 07:15:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35964 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYCTLPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 07:15:08 -0400
Date: Thu, 20 Mar 2008 12:14:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Subject: iommu breaks usb after resume
Message-ID: <20080320111429.GA14764@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 64-bit machine with 4GB ram (8core from amd), iommu breaks USB
after swsusp. iommu=soft fixes that issue.

I guess iommu handling in arch/x86/kernel/ should have some
suspend/resume support, as it manipulates hardware registers...?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
