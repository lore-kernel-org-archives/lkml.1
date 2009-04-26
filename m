Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZDZDgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZDZDgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 23:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZDZDg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 23:36:29 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:53142 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZDZDg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 23:36:29 -0400
Date: Sat, 25 Apr 2009 23:35:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: cleanup:  lot of folks redefining min() and max()
Message-ID: <alpine.LFD.2.00.0904252333320.8508@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  pretty sure we don't need to keep doing that since it's done in
include/linux/kernel.h.

drivers/scsi/ips.h:92:      #define min(x,y) ((x) < (y) ? x : y)
drivers/media/dvb/siano/smscoreapi.h:46:#define min(a, b) (((a) < (b)) ? (a) : (b))
drivers/net/tehuti.h:79:#define MIN(x, y)  ((x) < (y) ? (x) : (y))
drivers/staging/comedi/drivers/pcmda12.c:58:#define MIN(a,b) ( ((a) < (b)) ? (a) : (b) )
drivers/staging/comedi/drivers/pcmmio.c:79:#define MIN(a,b) ( ((a) < (b)) ? (a) : (b) )
drivers/staging/comedi/drivers/pcmuio.c:82:#define MIN(a,b) ( ((a) < (b)) ? (a) : (b) )
drivers/staging/sxg/sxg.h:430:#define MIN(a, b) ((u32)(a) < (u32)(b) ? (a) : (b))
drivers/staging/sxg/sxg.h:431:#define MAX(a, b) ((u32)(a) > (u32)(b) ? (a) : (b))
drivers/staging/rt2870/rtmp.h:715:#define min(_a, _b)     (((_a) < (_b)) ? (_a) : (_b))
drivers/staging/rt2870/rtmp.h:719:#define max(_a, _b)     (((_a) > (_b)) ? (_a) : (_b))
drivers/staging/rt2860/rtmp.h:785:#define min(_a, _b)     (((_a) < (_b)) ? (_a) : (_b))
drivers/staging/rt2860/rtmp.h:789:#define max(_a, _b)     (((_a) > (_b)) ? (_a) : (_b))
drivers/staging/rt3070/rtmp.h:762:#define min(_a, _b)     (((_a) < (_b)) ? (_a) : (_b))
drivers/staging/rt3070/rtmp.h:766:#define max(_a, _b)     (((_a) > (_b)) ? (_a) : (_b))
drivers/staging/epl/EplDllkCal.c:94:#define min(a,b)            (((a) < (b)) ? (a) : (b))

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
