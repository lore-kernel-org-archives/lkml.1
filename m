Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYHSLx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYHSLx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYHSLxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:53:50 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40857 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbYHSLxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:53:50 -0400
X-BigFish: VPS-36(zz1432R98dR936eQ62a3L1805Mzz10d3izzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K5UJPB-01-4JU-01
Date: Tue, 19 Aug 2008 13:53:18 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>,
       cel <cel@linux.vnet.ibm.com>
Subject: Re: powerpc/cell/oprofile: avoid double free of profile buffer
Message-ID: <20080819115317.GD1488@erda.amd.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <18591.30474.127939.243247@cargo.ozlabs.ibm.com> <200808110918.57293.arnd@arndb.de> <200808110925.44243.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200808110925.44243.arnd@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 19 Aug 2008 11:53:38.0462 (UTC) FILETIME=[37ADCBE0:01C901F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.08.08 09:25:43, Arnd Bergmann wrote:
> From: Carl Love <cel@us.ibm.com>
> 
> If an error occurs on opcontrol start, the event and per cpu buffers
> are released.  If later opcontrol shutdown is called then the free
> function will be called again to free buffers that no longer
> exist.  This results in a kernel oops.  The following changes
> prevent the call to delete buffers that don't exist.
> 
> Signed-off-by: Carl Love <carll@us.ibm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Robert Richter <robert.richter@amd.com>

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

