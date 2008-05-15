Return-Path: <linux-kernel-owner+w=401wt.eu-S1764994AbYEOVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764994AbYEOVmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYEOVmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:42:00 -0400
Received: from sandeen.net ([209.173.210.139]:26000 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbYEOVl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:41:59 -0400
Message-ID: <482CAE26.8080707@sandeen.net>
Date: Thu, 15 May 2008 16:41:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Marco Berizzi <pupilla@hotmail.com>
CC: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper:
 page allocation failure. order:3, mode:0x4020)
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com> <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl> <20080506085632.GT155679365@sgi.com> <BAY103-DAV78BE1E59193F0C8852503B2D60@phx.gbl> <482062F5.9010402@sandeen.net>
In-Reply-To: <482062F5.9010402@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Marco Berizzi wrote:
>> David Chinner wrote:
>>
>>> Hmmmmm - interesting. Both the reports of this problem are from
>>> machines running as squid proxies. Are you using AUFS for the cache?
>> no, I'm using cache_dir ufs with cache_replacement_policy heap LFUDA

Christoph recently sent a patch to the xfs list which resolves my
testcase for this problem, FYI.

[PATCH] fix memory corruption with small buffer reads

-Eric
