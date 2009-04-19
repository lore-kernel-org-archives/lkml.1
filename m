Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbZDSGfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbZDSGfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZDSGfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:35:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:49119 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbZDSGfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:35:24 -0400
MIME-Version: 1.0
Date: Sun, 19 Apr 2009 07:27:35 +0100
X-Google-Sender-Auth: f5aa821ba20c9585
Message-ID: <b2cdc9f30904182327w12a3ec32t90c7c6c34980577b@mail.gmail.com>
Subject: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
From: Alex Bennee <kernel-hacker@bennee.com>
To: xorg <xorg@lists.freedesktop.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heading the warnings in the menuconfig I did try and ensure I have all
the up to date parts of user-space. With KMS enabled GDM starts up but
then corrupts the display with vertical lines. Disabling the kernel
config and everything starts up fine, UXA acceleration seems OK and
the speed of compiz is finally back up to ~60fps thanks to the A17
fix.

Am I missing another bit of user space for KMS to work properly?

I am seeing a:

[    6.751092] BUG: using smp_processor_id() in preemptible [00000000]
code: modprobe/3078
[    6.751100] caller is smp_call_function_many+0x29/0x1bd
[    6.751103] Pid: 3078, comm: modprobe Not tainted 2.6.30-rc2-ajb #56

But I think it's unrelated to any X woes. Shall detail in another message.

-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
