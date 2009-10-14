Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbZJNVGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbZJNVGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759118AbZJNVGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:06:36 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59574 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZJNVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:06:35 -0400
Date: Wed, 14 Oct 2009 23:05:58 +0200
From: Andreas Mohr <andi@lisas.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: System (motherboard/CPU?) emits high pitch noise when
	processor.ko is loaded.
Message-ID: <20091014210558.GA15555@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910141443460.5747@p34.internal.lan>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And that's news exactly how? ;)
Systems and their switching regulators (and especially their backing
coils) have been making noise for more than half a decade now,
depending on which activities frequency is currently taking place
on the system.

OTOH this means that in your case, maybe some interval in the processor module
(or somewhere related) is ill-chosen (leading to significant, audible differences
between busy/idle state) and should be changed.

For example, with HZ settings 100 can cause quite a bit of noise on some
machines, whereas 1000 is better, IIRC. And that could be similar for some
processing in this module.

Andreas
