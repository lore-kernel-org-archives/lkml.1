Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbZJMQk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbZJMQk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZJMQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:40:28 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:32958 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZJMQk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:40:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uEopfQfc9MYmsGBbT4ngXIVj4cmujgU+jiwXsqbarno6VyiFlU+Yz7avo3yHwNMqtd
         pSC5BwN3D50FNB6AhKkB1wx+4rOW4GmyIwEDs7iyvUaCHUnpPU/pbh7/1YPNebKfdqjc
         bZMNVIgno0BJ/Ph2IkBIyni7RSobnWyClu5+0=
MIME-Version: 1.0
Date: Tue, 13 Oct 2009 09:39:50 -0700
Message-ID: <4c44d90b0910130939m4ee26375ofb0541e05a7f514e@mail.gmail.com>
Subject: [PATCH] [FIX] Include hrtimer.h in timer.h
From: Thomas DuBuisson <thomas.dubuisson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC on responses


Include <linux/hrtimer.h> to make timer.h ansi compliant

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
