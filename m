Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYJZDBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYJZDBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 23:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYJZDBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 23:01:39 -0400
Received: from smtp2.Stanford.EDU ([171.67.20.25]:34007 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbYJZDBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 23:01:38 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2008 23:01:38 EDT
Subject: 2.6.26.[6|7] vs. rt11 vs. alsa (usb) midi
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Cc: Fernando Pablo Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 19:46:27 -0700
Message-Id: <1224989187.3706.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi... anyone out there also having problem with this combination?
   2.6.26.7 or 2.6.26.6 with 2.6.26.6-rt11 and alsa MIDI
It looks to me like alsa midi is broken. 

Probably an interaction with the realtime kernel patch. A Fedora kernel
based on 2.6.26.6 (2.6.26.6-49 on fc8) works fine, a very similarly
patched kernel that includes the realtime patch does not. The
configurations for both are almost the same (today I tried to change
some of the most obvious differences and rebuild, with the same
result). 

No problems with 2.6.24.7-rt21. 

Test: boot, login, plugin an external usb keyboard (Yamaha P250), it is
recognized, use qjackctl alsa patchbay to connect it to kmidimon,
kmidimon sees only _one_ midi message and that's it. Kmidimon can't be
killed after that. 

-- Fernando


