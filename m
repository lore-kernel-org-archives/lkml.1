Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYLDBeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYLDBeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYLDBdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:33:52 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:64284 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYLDBdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:33:52 -0500
Message-ID: <49373373.2080901@oracle.com>
Date: Wed, 03 Dec 2008 17:33:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sameo@openedhand.com
Subject: Re: linux-next: Tree for December 3 (MFD)
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
In-Reply-To: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49373376.0061:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20081202:
> 
> Today's tree fails the powerpc allyesconfig build.


drivers/mfd/twl4030-core.c uses clk_get_rate() and clk_put(),
but they don't seem to exist for x86, so I'm getting build errors:

twl4030-core.c:(.text+0x16a797): undefined reference to `clk_get_rate'
twl4030-core.c:(.text+0x16a7a6): undefined reference to `clk_put'


~Randy
