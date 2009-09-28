Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZI1R4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZI1R4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZI1R4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:56:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45857 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZI1R4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:56:07 -0400
Date: Mon, 28 Sep 2009 19:56:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org
Subject: 32-rc1: "CROSS_COMPILE changed" message breaks compilation
Message-ID: <20090928175605.GB28514@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After update to 2.6.32-rc1, I'm getting

"Makefile:197: *** CROSS_COMPILE changed from "ccache" to to "ccache ". Use "make mrproper" to fix it up. Stop.

Note that the message has typo in it ("to to")... What is worse, the
message triggers even when I try to run make mrproper. Ouch.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
