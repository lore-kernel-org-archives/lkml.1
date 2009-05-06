Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbZEFPxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbZEFPxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbZEFPx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:53:28 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:50631 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400AbZEFPx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:53:26 -0400
Message-ID: <4A01B2D6.8080901@oracle.com>
Date: Wed, 06 May 2009 08:55:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 6 (fs/)
References: <20090506172653.2f1bbedd.sfr@canb.auug.org.au>
In-Reply-To: <20090506172653.2f1bbedd.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A01B26F.01C8:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090505:



When CONFIG_BLOCK=n:

fs/super.c:278: error: implicit declaration of function 'sync_filesystem'

and after changing include/linux/fs.h so that that declaration is outside of
CONFIG_BLOCK=y/n:

fs/sync.c:40: error: implicit declaration of function '__sync_blockdev'


-- 
~Randy
