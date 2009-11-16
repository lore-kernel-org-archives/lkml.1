Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbZKPESc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbZKPESc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZKPESb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:18:31 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56872 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZKPESa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:18:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EY0M4O9yYyf0dszIC0SSoaBR18O+Z7xDG+EXIZUHn9FMKNF7FvcOICY/DR4tx147Do
         AcpdcCXME/oDPRaksvejOy8mhxRxkHGoUexfMSWXvTE9+fT5fKo3SXsvBFbzcG+Hc2Tz
         1ZMPKbCaexzUyJVffOSOGGLzSEF59FfII8Lhk=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 00/13] staging: line6 cleanups
Date: Sun, 15 Nov 2009 22:17:49 -0600
Message-Id: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix formatting and checkpatch errors/warnings
for some of the files in the line6 driver.

Shawn Bohrer (13):
  staging: line6: Lindent and fix checkpatch warnings in playback.c
  staging: line6: Fix checkpatch errors in playback.c
  staging: line6: Lindent and fix checkpatch warnings in capture.c
  staging: line6: Fix checkpatch errors in capture.c
  staging: line6: Lindent control.c
  staging: line6: Fix some checkpatch warnings in control.c
  staging: line6: Convert simple_strtoul() to strict_strtoul in
    control.c
  staging: line6: Fix checkpatch warnings in pcm.c
  staging: line6: Lindent and fix some checkpatch warnings in
    toneport.c
  staging: line6: Convert simple_strtol to strict_strtol in toneport.c
  staging: line6: Convert simple_strtoul to strict_strtoul in variax.c
  staging: line6: Convert simple_strtoul to strict_strtoul in pod.c
  staging: line6: Convert simple_strtoul to strict_strtoul in midi.c

 drivers/staging/line6/capture.c  |   98 +++++---
 drivers/staging/line6/control.c  |  493 +++++++++++++++++++++++++-------------
 drivers/staging/line6/midi.c     |   16 +-
 drivers/staging/line6/pcm.c      |    3 +-
 drivers/staging/line6/playback.c |  101 +++++---
 drivers/staging/line6/pod.c      |   56 ++++-
 drivers/staging/line6/toneport.c |  119 +++++----
 drivers/staging/line6/variax.c   |   31 ++-
 8 files changed, 611 insertions(+), 306 deletions(-)

