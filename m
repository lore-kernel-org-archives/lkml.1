Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZBIQxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZBIQxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZBIQxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:53:41 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:60839 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZBIQxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:53:40 -0500
Message-ID: <49905F93.300@oracle.com>
Date: Mon, 09 Feb 2009 08:53:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       swise@chelsio.com, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: linux-next: Tree for February 9 (infiniband)
References: <20090209193908.1a448944.sfr@canb.auug.org.au>
In-Reply-To: <20090209193908.1a448944.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49905F81.00F4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> [I accidentally deleted the merge and quilt-import logs today :-( - I
> wonder if any would have noticed :-).  The merge summary still appears
> below.]
> 
> Changes since 20090206:


allyesconfig build on i386 fails with:

drivers/built-in.o: In function `iwch_sgl2pbl_map':
/usr/builds/linux-next-20090209/drivers/infiniband/hw/cxgb3/iwch_qp.c:237: undefined reference to `__umoddi3'
make: *** [.tmp_vmlinux1] Error 1


or allmodconfig on i386 fails with:

ERROR: "__umoddi3" [drivers/infiniband/hw/cxgb3/iw_cxgb3.ko] undefined!

-- 
~Randy
