Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbYAVPIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbYAVPIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYAVPIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:08:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:44116 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750781AbYAVPID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:08:03 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+neEBd77inxK6iQrrahC9mWARbdEIKW1YmRqY3/8
	r6h8RL3msT93DN
Date: Tue, 22 Jan 2008 16:08:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: Sakari Ailus <sakari.ailus@nokia.com>
cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: [MUST-FIX] in today's Linus' git
Message-ID: <Pine.LNX.4.64.0801221601460.6933@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Could someone, please, fix this:

drivers/media/video/tcm825x.c:

853:	if (sensor->platform_data == NULL
854:	    && !sensor->platform_data->is_okay())

I haven't looked through the entire file, so, cannot guarantee, that this 
is the only place. Maybe, someone could review this file and the whole 
commit it came in with properly...

Thanks
Guennadi
---
Guennadi Liakhovetski
