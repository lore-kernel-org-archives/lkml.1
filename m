Return-Path: <linux-kernel-owner+w=401wt.eu-S940548AbXGaCxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940548AbXGaCxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759448AbXGaCxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:53:05 -0400
Received: from kludge.physics.uiowa.edu ([128.255.33.129]:54554 "EHLO
	kludge.physics.uiowa.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbXGaCxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:53:03 -0400
X-Greylist: delayed 2177 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 22:53:03 EDT
Date: Mon, 30 Jul 2007 21:16:16 -0500
From: Joseph Pingenot <trelane@digitasaru.net>
To: linux-kernel@vger.kernel.org
Message-ID: <20070731021615.GB6812@digitasaru.net>
Reply-To: trelane@digitasaru.net
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-School: University of Iowa
X-vi-or-emacs: vi *and* emacs!
X-MS-TNEF-Correlator: <AFJAUFHRUOGRESULWAOIHFEAUIOFBVHSHNRAIU.monkey@spamcentral.invalid>
X-MimeOLE: Not Produced By Microsoft MimeOLE V5.50.4522.1200
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Subject: inotify and /proc/<pid>
X-SA-Exim-Version: 4.2.1 (built Thu, 26 Apr 2007 18:30:04 +0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to use inotify to watch process changes (especially process
  termination) by watching /proc/<pid>.

Sadly, although I could see something reading various files, nothing
  was issued when the process I was watching exited and the directory
  went away.

Is this intentional, or a bug?

-Joseph
-- 
trelane@digitasaru.net.///////////////////////////////////////////////
"There is also an entire branch in the physical therapy field dedicated
 to the treatment of little-finger injuries caused by excessive Emacs
 use."  --Linux Weekly News editor (http://lwn.net/Articles/206916/)
///////260 IATL / The University of Iowa / Iowa City, IA  52242///////
