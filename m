Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZAaTyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZAaTyB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZAaTxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:53:53 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:27953 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZAaTxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:53:52 -0500
Message-ID: <4984AC40.8030708@oracle.com>
Date: Sat, 31 Jan 2009 11:53:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-01-31-01-08 uploaded (staging vs. mach64: CONFIG_PANEL)
References: <200901310909.n0V99XIZ021497@imap1.linux-foundation.org>
In-Reply-To: <200901310909.n0V99XIZ021497@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4984AC43.00FC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-01-31-01-08 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


drivers/staging/panel/Kconfig: config PANEL
vs. include/video/mach64.h: #define CONFIG_PANEL	0x00


When staging's CONFIG_PANEL=y (is enabled), the mach64.h header file gets
lots of these:

include/video/mach64.h:1257:1: warning: "CONFIG_PANEL" redefined


so staging adds a new config symbol that conflicts with the
(incorrect namespace) usage in mach64.h.

mach64 needs to change IMO, even though it is older.

-- 
~Randy
