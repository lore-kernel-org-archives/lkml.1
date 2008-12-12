Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYLLHDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYLLHDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYLLHDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:03:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:49906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYLLHDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:03:21 -0500
Message-ID: <49420B85.1040402@manoweb.com>
Date: Thu, 11 Dec 2008 22:58:13 -0800
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Keyboard not attached to any console
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1892FaQy2mSHD0G4ylUWt0QA8goIrWkNTKiyWG
 C1UGO3diKyZmxzAzgWYmRirLjXYvWZbWkOYAJE42UUk8NwLv6i
 P/UMKlkRSfem4zebozFyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, how can I totally detach a keyboard from the console, so that I can
just open its /dev/input/eventX device and get exclusive use?

As far as I am concerned the console is on ttyS0 and I do not want
events from supplementary keyboards (PS/2 or USB) to be propagated to
anything else than applications explicitly opening the aforementioned
devices.

Back in 2.4 times I did something similar but now the whole input system
looks so different :)

In short I would like to:
- have full control of the LEDs (I do not want the num-lock key to
toggle the num-lock LED)
- not propagate things like ctrl+alt+del (I know I can disable this one
in inittab but that's not the point)

thank you
Alessio

