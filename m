Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXJKJD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXJKJD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbXJKJDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:03:50 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:42923 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbXJKJDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:03:49 -0400
X-Greylist: delayed 1679 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 05:03:49 EDT
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: linux-kernel@vger.kernel.org
Subject: "mount --bind" with user/group/mode definition?
Date: Thu, 11 Oct 2007 10:35:37 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710111035.38644.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

is there some way to duplicate a directory somewhere else (like 
with "mount --bind"), but having different owner/group/mode bits?

I'd like to mount a directory I have no control over (think NFS, or 
floppy, ...) with clearly defined rights - like root:<some group>, mode 0550 
for all directories, and 0440 for all files.
(Here I want to have full *read* control, regardless of the original 
permissions).
[ I know that this special case can be (mostly) done by a read-only binding
  mount; the part that is missing is eg. files with a different owner being
  0700. ]

I know that something like this is possible for eg. VFAT, which has no right 
descriptors for itself; but I'd need that for arbitrary directory trees, who 
themselves *have* permissions set.


Is there some way to achieve that?


Regards,

Phil
