Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381Ab0AKO6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0AKO6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 09:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328Ab0AKO6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 09:58:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:36113 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751379Ab0AKO6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 09:58:49 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19Lid868q1LQe0iiDxl7j1X7fZDv5vGg24bVSx+Zr
	FWzS6jJIUHicBX
Date: Mon, 11 Jan 2010 15:59:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: dmaengine: query current transfer status
Message-ID: <Pine.LNX.4.64.1001111550270.6492@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.70999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm using the dmaengine API with an ASoC driver (soon to be submitted), 
and I have to provide a callback to ALSA to query the progress of the 
current transfer (the .pointer() method from struct snd_pcm_ops). 
Currently I only can provide this information with a period size 
precision. Wouldn't it make sense to add an optional hook to dmaengine for 
that? I certainly could add this as a platform-specific extension to the 
specific dmaengine driver, I'm using (shdma), but that'd be ugly. Ideas? 
Specific proposals for the prototype? I could cook up a patch if there are 
no principal objections against this.

Thanks
Guennadi
---
Guennadi Liakhovetski
