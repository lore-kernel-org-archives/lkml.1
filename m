Return-Path: <linux-kernel-owner+w=401wt.eu-S934463AbYEIBhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463AbYEIBhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760545AbYEIBgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:36:54 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:51172 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760030AbYEIBgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:36:53 -0400
Message-ID: <4823AAF2.7070102@keyaccess.nl>
Date: Fri, 09 May 2008 03:37:54 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Glauber Costa <gcosta@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

commit 8779f2fc3b84ebb6c5181fb13d702e9944c16069

"x86: don't try to allocate from DMA zone at first"

breaks all of ISA DMA. Or all of ALSA ISA DMA at least. All
ISA soundcards are silent following that commit -- no error
messages, everything appears fine, just silence.

It won't just revert due to 32/64 merge.

Rene.


