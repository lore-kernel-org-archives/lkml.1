Return-Path: <linux-kernel-owner+w=401wt.eu-S1030212AbXAYPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212AbXAYPjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030209AbXAYPjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:39:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212AbXAYPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:39:18 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 10:39:18 EST
From: Gerhard Dirschl <gd@spherenet.de>
To: Peter Osterlund <petero2@telia.com>
Subject: Re: 2.6.20-rc5: known unfixed regressions (v3) (part 2)
Date: Thu, 25 Jan 2007 16:32:41 +0100
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org> <20070124154725.GK17836@stusta.de> <m3y7nsi266.fsf@telia.com>
In-Reply-To: <m3y7nsi266.fsf@telia.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200701251632.41579.gd@spherenet.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9a410c39813cf3098e4757d92f0a362c
X-Provags-ID2: V01U2FsdGVkX18nyhcT3LXJ4U+HWoKAQUaV9NUvgBZ45SjXpEtV8hYYO3MzXTrOlDGdXT1kF9phSdjMmnP2LQC1HZ3RnNN/fkvmpJPaKYeleCc9kcedfZktJw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 24 Januar 2007 21:45 schrieb Peter Osterlund:
> > Subject    : pktcdvd fails with pata_amd
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=7810
> > Submitter  : gd@spherenet.de
> > Status     : unknown
> Does reverting this patch help?
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=406c9b605cbc45151c03ac9a3f95e9acf050808c
No, the machine locks up as described in
http://bugzilla.kernel.org/show_bug.cgi?id=7667
But it worked after additional reverting of
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3b00315799d78f76531b71435fbc2643cd71ae4c
(testted with 2.6.20-rc6).

-- 
Gerhard Dirschl        PGP-Key-ID: 0x7B95AE94
Karlsruhe
Germany
