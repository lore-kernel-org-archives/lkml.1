Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYHQMp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYHQMp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbYHQMp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:45:27 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:35068 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbYHQMpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:45:25 -0400
Date: Sun, 17 Aug 2008 14:45:11 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: sysprof in 2.6.27 kernel
Message-ID: <20080817124511.GS4674@ics.muni.cz>
References: <20080813083953.GF19333@ics.muni.cz> <ye8myjg7b4r.fsf@camel10.daimi.au.dk> <20080814111022.GC4674@ics.muni.cz> <ye84p5l7jwp.fsf@camel28.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ye84p5l7jwp.fsf@camel28.daimi.au.dk>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 17 Aug 2008 14:45:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 04:50:30AM +0200, Soeren Sandmann wrote:
> This may be because sysprof user space is not running as root, or it
> may be because the kernel is generating bogus addresses. 

if I do not run it as root, the collecor does not start at all.
 
> Generally, "No Map" means sysprof is seeing samples in memory regions
> that are not in /proc/<pid>/maps

yes, that could be because only null addresses are received.

-- 
Luká¹ Hejtmánek
