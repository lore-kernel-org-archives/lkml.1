Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0BIPYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:24:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33667 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0BIPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:24:45 -0500
Date: Tue, 9 Feb 2010 16:24:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: register long sp asm("r1") incorrect
Message-ID: <20100209152444.GA30176@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...according to gcc docs, sp should be global, or placement in
register is not guaranteed (except at asm boundaries, but there are
none).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
