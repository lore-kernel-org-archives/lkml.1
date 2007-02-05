Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbXBEQvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbXBEQvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbXBEQvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:51:41 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:37343 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXBEQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=SHIWBxI7myvPY3AI1S42T+rgSAC5h7Zd00yCgvvbe4W2+bON2fhU8Mhre1eg418pVsmTd1CgLFKseudI7BfYrGu/SJMdozIdH2bUHyeuzIr7FGBGGRPuwl+k+l3Uy/yjpvlnUUfSgJv+vig1im+MkuHS6KDUc/eH/EtAw4CVv2U=
Date: Mon, 5 Feb 2007 18:51:34 +0200
To: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH 00] A series of patches to use ARRAY_SIZE under video subtree
Message-ID: <20070205165134.GA3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Follows is a series of patches to use ARRAY_SIZE macro in the video drivers
located under /drivers/media/video.
Patches are test compiled and can be applied cleanly on 2.6.20

 cpia2/cpia2_v4l.c             |    9 +++++----
 ov7670.c                      |    7 ++++---
 pvrusb2/pvrusb2-audio.c       |   10 ++++------
 pvrusb2/pvrusb2-ctrl.c        |    4 ++--
 pvrusb2/pvrusb2-cx2584x-v4l.c |   10 ++++------
 pvrusb2/pvrusb2-debugifc.c    |    5 +++--
 pvrusb2/pvrusb2-eeprom.c      |    3 ++-
 pvrusb2/pvrusb2-hdw.c         |    3 ++-
 tveeprom.c                    |    6 +++---
 tvp5150.c                     |    3 ++-
 usbvideo/quickcam_messenger.c |    2 +-
 11 files changed, 32 insertions(+), 30 deletions(-)

Thanks,
-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
