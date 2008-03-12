Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbYCLOk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbYCLOk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYCLOkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:40:49 -0400
Received: from gherkin.frus.com ([192.158.254.49]:33428 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbYCLOks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:40:48 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <ED0F0070-B876-4D8B-8F88-879E01AB4326@orcon.net.nz>
 "from Michael Cree at Mar 12, 2008 09:00:13 am"
To: Michael Cree <mcree@orcon.net.nz>
Date: Wed, 12 Mar 2008 09:40:21 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080312144021.3FE57DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I built a 2.6.22 kernel last night, and in tests this morning
there's no difference relative to the ALSA behavior seen in 2.6.25-rc4.
Since the question came up (or was strongly implied), I took the time to
check the status of IRQ 5 in /proc/interrupts, and while it shows up as
assigned to the sound card, no interrupts are being seen/processed by
the es18xx driver.  When I remove the snd-es18xx module and install the
snd-sb8 module with the same parameters (other than there's no second
DMA channel), the /proc/interrupts counter for IRQ 5 increments as
expected when playing sound files.

At this point I'm pretty sure the es18xx issue isn't a regression: it's
"just" a bug that has been around since I first loaded 2.6.X on my
Alpha.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
