Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYBCV2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYBCV2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYBCV2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:28:39 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:33497 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYBCV2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:28:38 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Feb 2008 16:28:38 EST
Date: Sun, 3 Feb 2008 13:21:55 -0800
From: Robin Lee Powell <rlpowell@digitalkingdom.org>
To: linux-kernel@vger.kernel.org
Subject: Monthly md check == hung machine; how do I debug?
Message-ID: <20080203212155.GF12173@digitalkingdom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've got a machine with a 4 disk SATA raid10 configuration using md.
The entire disk is loop-AES encrypted, but that shouldn't matter
here.

Once a month, Debian runs:

    /usr/share/mdadm/checkarray --cron --all --quiet

and the machine hangs within 30 minutes of that starting.

It seems that I can avoid the hang by not having "mdadm --monitor"
running, but I'm not certain if that's the case or if I've just been
lucky this go-round.

I'm on kernel 2.6.23.1, my own compile thereof, x86_64, AMD
Athlon(tm) 64 Processor 3700+.

I've looked through all the 2.6.23 and 2.6.24 Changelogs, and I
can't find anything that looks relevant.

So, how can I (help you all) debug this?

-Robin

-- 
Lojban Reason #17: http://en.wikipedia.org/wiki/Buffalo_buffalo
Proud Supporter of the Singularity Institute - http://singinst.org/
http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/
