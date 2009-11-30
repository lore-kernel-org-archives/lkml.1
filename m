Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbZK3SH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbZK3SH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZK3SH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:07:28 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:39134 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbZK3SH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:07:27 -0500
Message-ID: <4B1409D9.1050901@oracle.com>
Date: Mon, 30 Nov 2009 10:07:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for November 30 (media/common/tuners/max2165)
References: <20091130175346.3f3345ed.sfr@canb.auug.org.au>
In-Reply-To: <20091130175346.3f3345ed.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B1409DF.00EB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20091127:
> 
> The v4l-dvb tree lost its conflict.


on i386 (X86_32):

a 'double' variable is used, causing:

ERROR: "__floatunsidf" [drivers/media/common/tuners/max2165.ko] undefined!
ERROR: "__adddf3" [drivers/media/common/tuners/max2165.ko] undefined!
ERROR: "__fixunsdfsi" [drivers/media/common/tuners/max2165.ko] undefined!


-- 
~Randy
