Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZGCGGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZGCGGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZGCGGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:06:11 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:57532 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZGCGGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=geby4YilKebA23vckrzR46/VnkM5UIkMF/zMlSwEQMTymE8iM/3VCW1GLL5d523IQF
         UTrAlz6KeJA267iE3gyoiIDX+hvA5V00dx4uGhovqk5c894JQAp6yuBR3AbmJpmMzwPe
         3T+mEMEr9zH+qr2v6zPkTXM2Y49h90rgJN9b0=
MIME-Version: 1.0
Date: Fri, 3 Jul 2009 11:36:13 +0530
Message-ID: <f1c9d250907022306j4ea1eb3g47101bd4a9528f61@mail.gmail.com>
Subject: ring-buffer: Kernel threads cpu utilization.
From: Tej <bewith.tej@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: srostedt@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rb_producer and rb_comsumer, kernel thread uses lot of CPU (~100%)
bandwidth every 10s.

bisection results commit:
[5092dbc96f3acdac5433b27c06860352dc6d23b9] ring-buffer: add benchmark and tester
I have read commit logs:
git log -r 5092dbc96f3acdac5433b27c06860352dc6d23b9

Is it correct behavior for these thread to consume this much cpu
bandwidth even if someone selects rb benchmarks config options?

thanks
-tej
