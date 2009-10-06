Return-Path: <linux-kernel-owner+w=401wt.eu-S933793AbZJFWVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbZJFWVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933750AbZJFWU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:20:57 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:62976 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933703AbZJFWUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=IDFbuQW8A7VF9HFlTgNlb3oyMZ0OBqRKLflAj1NmEesR1mS4Dg7YEs8ijiZso+SeY9
         IjHihQF6IRaKAadEhiBiwBGtYFW9qu58p/YWwI8EPuin1KwsV+PdBkPsABpSfN/X9OA5
         8ailZM/MCBFhX6TWNAWn68zy36BWjYhAwVokg=
MIME-Version: 1.0
Date: Tue, 6 Oct 2009 15:20:16 -0700
Message-ID: <4c44d90b0910061520o36adc7m50419be3a3d9d0fa@mail.gmail.com>
Subject: [PATCH] Include hrtimer.h for ANSI compliance
From: Thomas DuBuisson <thomas.dubuisson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include <linux/hrtimer.h> to make pci.h ansi compliant (it references
an hrtimer enum).

Please CC on responses.

Signed-off-by: Thomas DuBuisson <Thomas.DuBuisson@gmail.com>
---
include/linux/timer.h |    1 +
1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index a2d1eb6..ad2b3cb 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -6,6 +6,7 @@
#include <linux/stddef.h>
#include <linux/debugobjects.h>
#include <linux/stringify.h>
+#include <linux/hrtimer.h>

struct tvec_base;

--
1.6.2.5
