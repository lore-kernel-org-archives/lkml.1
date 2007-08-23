Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXHWVre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXHWVre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761493AbXHWVr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:47:26 -0400
Received: from khc.piap.pl ([195.187.100.11]:44783 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049AbXHWVrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:47:25 -0400
To: Chris Snook <csnook@redhat.com>
Cc: Anand Jahagirdar <anandjigar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	<46C4BC46.7000305@redhat.com>
	<25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>
	<46C9A867.6090509@redhat.com>
	<25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com>
	<m3d4xeii2z.fsf@maximus.localdomain> <46CDD98F.2020208@redhat.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 23 Aug 2007 23:47:22 +0200
In-Reply-To: <46CDD98F.2020208@redhat.com> (Chris Snook's message of "Thu, 23 Aug 2007 15:01:35 -0400")
Message-ID: <m34pipgbyt.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> writes:

> Wrapping a single printk that's unrelated to debugging in an #ifdef
> CONFIG_* or a sysctl strikes me as abuse of those configuration
> facilities.

Abuse, probably not (if a thing is required on one system and must
not be on another, it has to be configurable). If the printk is
a good idea... IMHO hardly, at best. We don't warn about trying to
write to /vmlinuz after all.

ulimit/pam_limits should fix the (IMHO nonexistent) problem nicely.
One has to plug all the holes, though (e.g. $HOME/.forward).
-- 
Krzysztof Halasa
