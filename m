Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYIYQxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYIYQxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYIYQxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:53:42 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:33695 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbYIYQxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:53:42 -0400
Date: Thu, 25 Sep 2008 18:54:00 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_SECURITY_ROOTPLUG [was: Re: 2.6.27-rc7 no init found on the
	root partition?]
Message-ID: <20080925165400.GQ31582@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 25 Sep 2008 18:53:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I finally found my problems with no init found.

It was caused by the CONFIG_SECURITY_ROOTPLUG option.

I wonder why this option in 2.6.26.3 kernel allows the kernel boot up, while
with 2.6.27-rc7, the kernel is unable to run even init.

-- 
Luká¹ Hejtmánek
