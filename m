Return-Path: <linux-kernel-owner+w=401wt.eu-S935411AbXJPWut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935411AbXJPWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbXJPWuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:50:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42381
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754718AbXJPWuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:50:39 -0400
Date: Tue, 16 Oct 2007 15:50:44 -0700 (PDT)
Message-Id: <20071016.155044.82377336.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, krzysztof.h1@wp.pl, perex@perex.cz
Subject: suspicious ALSA empty commit
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While scanning over today's updates in Linus's tree, I noticed
the following commit has no changes, and this does not appear
to be intentional.

Someone should check it out.

commit e31b6656a81d6332cdf6af17d38a0573128a6aac
Author: Krzysztof Helt <krzysztof.h1@wp.pl>
Date:   Tue Oct 16 14:54:58 2007 +0200

    [ALSA] This simplifies and fixes waiting loops of the mce_down()
    
    function after Trent Piepho's patch for AD1848.
    It also makes busy_wait() function call not atomic.
    
    Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Jaroslav Kysela <perex@perex.cz>
