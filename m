Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZGKLD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZGKLD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZGKLDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:03:19 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:48072 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZGKLDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:03:19 -0400
Date: Sat, 11 Jul 2009 07:01:02 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: what means "module_param(channel_mask, channel_mask, 0644)"?
Message-ID: <alpine.LFD.2.00.0907110658370.4257@localhost>
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


  researching my next newbie column about module parameters and i ran
across the following:

drivers/input/misc/ati_remote2.c:module_param(channel_mask, channel_mask, 0644);
drivers/input/misc/ati_remote2.c:module_param(mode_mask, mode_mask, 0644);

i have no idea what it means to have the second (type) field of
module_param() simply repeat the name of the parameter.  is this some
strange magic?  those two names don't *appear* to be typedef'ed
anywhere i can see.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
