Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbXJHWCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbXJHWCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbXJHWCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:02:00 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:33038 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbXJHWB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:01:59 -0400
Message-ID: <470AA886.4070309@aitel.hist.no>
Date: Tue, 09 Oct 2007 00:00:38 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc9 compile error drivers/video/fbmon.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/video/fbmon.o
drivers/video/fbmon.c: In function ‘fb_parse_edid’:
drivers/video/fbmon.c:867: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attrib
_’ before ‘*’ token
drivers/video/fbmon.c:867: error: ‘block’ undeclared (first use in this func
)

This line reads:
    unsigned char$*block;

Source error, or is my tree simply corrupt?

Helge Hafting
