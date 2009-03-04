Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZCDMik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZCDMik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZCDMib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:38:31 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:36852 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZCDMia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:38:30 -0500
Date: Wed, 4 Mar 2009 13:38:36 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drop_caches ...
Message-ID: <20090304123836.GA13706@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 04 Mar 2009 13:38:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> So you don't have lots of mapped pages(Mapped=51M) or tmpfs files. It's
> strange to me that there are so many undroppable cached pages(Cached=359M),
> and most of them lie out of the LRU queue(Active+Inactive file=53M)...

> Anyone have better clues on these 'hidden' pages?

I think he is simply using Intel driver + GEM + UXA = TONS of drm mm objects
in tmpfs which is 'hidden' unless you have /proc/filecache to see them.

-- 
Luká¹ Hejtmánek
