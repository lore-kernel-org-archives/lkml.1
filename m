Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbZEFQEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbZEFQEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZEFQEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:04:06 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:40175 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbZEFQEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:04:04 -0400
Message-ID: <4A01B54D.90301@oracle.com>
Date: Wed, 06 May 2009 09:05:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: linux-next: Tree for May 6 (fs/quota)
References: <20090506172653.2f1bbedd.sfr@canb.auug.org.au>
In-Reply-To: <20090506172653.2f1bbedd.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A01B4E9.00CB:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090505:


When
# CONFIG_QUOTA is not set
CONFIG_QUOTACTL=y
CONFIG_XFS_QUOTA=y

fs/quota/quota.c:163: error: redefinition of 'sync_quota_sb'
include/linux/quotaops.h:338: error: previous definition of 'sync_quota_sb' was here


-- 
~Randy
