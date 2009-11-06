Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbZKFXMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbZKFXMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759934AbZKFXMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:12:42 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54211 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758688AbZKFXMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:12:41 -0500
Subject: Re: [PATCH -next] kmemleak: fix kconfig for crc32 build error
From: Catalin Marinas <catalin.marinas@arm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AF4B259.8030506@oracle.com>
References: <20091106181330.80bca052.sfr@canb.auug.org.au>
	 <4AF4B259.8030506@oracle.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 06 Nov 2009 23:12:30 +0000
Message-Id: <1257549150.19025.2.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Nov 2009 23:12:32.0170 (UTC) FILETIME=[9E4560A0:01CA5F36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 15:33 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> kmemleak uses crc32 functions so it needs to select CRC32.
> Fixes build error:
> 
> kmemleak.c:(.text+0x7ce62): undefined reference to `crc32_le'

Thanks for the patch. I'll included it in my kmemleak branch.

-- 
Catalin

