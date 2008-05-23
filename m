Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYEWOCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYEWOCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYEWOCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:02:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:54281 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752479AbYEWOC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:02:29 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+HN/UiLpOHQ4DegxmYsBGWNtixttk89fuVYdaH5M
	HvwhmiDvHzqZDP
Date: Fri, 23 May 2008 16:02:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: broonie@opensource.wolfsonmicro.com, liam.girdwood@wolfsonmicro.com
Subject: wm97xx-core: wrong driver name?
Message-ID: <Pine.LNX.4.64.0805231551140.5494@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is this device_driver initialisation in 
drivers/input/touchscreen/wm97xx-core.c really correct (see "name")?

static struct device_driver wm97xx_driver = {
	.name =		"ac97",
	.bus =		&ac97_bus_type,
	.owner =	THIS_MODULE,
	.probe =	wm97xx_probe,
...
};

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
