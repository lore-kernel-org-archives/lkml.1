Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYIVSh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYIVSh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYIVShN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:37:13 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47971 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYIVShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:37:11 -0400
Message-ID: <48D7E5D7.3060703@lwfinger.net>
Date: Mon, 22 Sep 2008 13:37:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Logs being spammed with "Unable to enumerate USB device"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At times, my logs are filled with multiple copies of the following
message:

hub 4-0:1.0: unable to enumerate USB device on port 5

The output of lsusb is as follows:

Bus 003 Device 002: ID 04f2:b016 Chicony Electronics Co., Ltd
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

The hubs are built into an HP dv2815nr laptop, and nothing is plugged in.

I'm currently running v2.6.27-rc7 from the linux-2.6 git tree, but it
does not seem to be a regression. In checking my back logs, my first
such "storm" happened on July 25, with successive ones on September 8,
9, 12 and 21.

Is this an indication of hardware failure? What further info is
required? Any suggestions for debugging code to try to pinpoint the
problem?

Thanks,

Larry

