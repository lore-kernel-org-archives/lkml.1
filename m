Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbZLYJhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbZLYJhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 04:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZLYJhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 04:37:05 -0500
Received: from ironport2.lbl.gov ([128.3.41.14]:30826 "EHLO ironport2.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZLYJhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 04:37:03 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Dec 2009 04:37:03 EST
X-Ironport-SBRS: 4.5
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmAAAJsVNEuAAykYkWdsb2JhbACbWwEBAQEJCwoHEwW5f4QzBA
X-IronPort-AV: E=Sophos;i="4.47,453,1257148800"; 
   d="scan'208";a="105444766"
Date: Fri, 25 Dec 2009 01:31:09 -0800 (PST)
From: Andrei Gaponenko <andrei.gaponenko@cern.ch>
To: linux-kernel@vger.kernel.org
cc: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: drm/radeon/kms regression: 2.6.33-rc2 does not boot
Message-ID: <alpine.LFD.2.00.0912250124410.11466@x200s>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

One of my systems works fine with 2.6.32, but hangs when trying to
boot 2.6.33-rc2.  Git bisect says
7923c615b811945a9d9f456c92a7a32c34167458 is the first bad commit:

    drm/radeon/kms: make sure mc is initialized before mapping blit bo

    We need to make sure the the MC is intialized before we map the
    blit shader object on r6xx+.

(So the problem was already present in -rc1.)

The last message I see during a 2.6.33-rc2 boot is about attaching a
disk.  Then everything stops until I press Ctrl-Alt-Del.  With a
working kernel, the next thing would be switching the console to a
higher resolution mode.  The graphics card is 

01:00.0 VGA compatible controller: ATI Technologies Inc RV710 [Radeon HD 4350]

Please Cc me directly on replies.

Andrei
