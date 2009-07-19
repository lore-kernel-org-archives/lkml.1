Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbZGSNQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbZGSNQC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 09:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZGSNQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 09:16:01 -0400
Received: from rtr.ca ([76.10.145.34]:44871 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbZGSNQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 09:16:00 -0400
Message-ID: <4A631C8F.7000002@rtr.ca>
Date: Sun, 19 Jul 2009 09:15:59 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
       Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Regression 2.6.31:  xc5000 no longer works with Myth-0.21-fixes branch
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devin,

Thanks for your good efforts and updates on the xc5000 driver.
But the version in 2.6.31 no longer works with mythfrontend
from the 0.21-fixes branch of MythTV.

The mythbackend (recording) program tunes/records fine with it,
but any attempt to watch "Live TV" via mythfrontend just locks
up the UI for 30 seconds or so, and then it reverts to the menus.

I find that rather odd, as mythfrontend normally has very little
interaction with the tuner devices.  But it does try to read the
signal strength and quality from the tuner, so perhaps this is a
clue as to what has gone wrong?

I also took just the xc5000.[ch] files from 2.6.31 and tried them
with 2.6.30, to help isolate things.  Exactly the same behaviour
was observed there, too.  The mythbackend could tune/record,
but the mythfrontend would lock up.

???
