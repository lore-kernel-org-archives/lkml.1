Return-Path: <linux-kernel-owner+w=401wt.eu-S933567AbZJFVgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbZJFVgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933249AbZJFVgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:36:07 -0400
Received: from bu3sch.de ([62.75.166.246]:38377 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252AbZJFVfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:35:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: b43: fix wldev use after free
Date: Tue, 6 Oct 2009 23:35:09 +0200
User-Agent: KMail/1.9.9
Cc: Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091001084924.GA4170@darkstar> <20091006142822.55d5120c.akpm@linux-foundation.org>
In-Reply-To: <20091006142822.55d5120c.akpm@linux-foundation.org>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910062335.12069.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009 23:28:22 Andrew Morton wrote:
> > fix it by call b43_leds_unregister before b43_one_core_detach
> > if it is the last one in wl->devlist
> > 
> 
> It appears that a different fix was added to linux-next yesterday:

Yes, this one is better, because it doesn't really change the code. It just removes
one unnecessary pointer usage.

-- 
Greetings, Michael.
