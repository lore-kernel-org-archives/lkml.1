Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZKWXjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZKWXjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbZKWXjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:39:03 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:49667 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356AbZKWXjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:39:01 -0500
Message-ID: <4B0B1CCA.7070500@oracle.com>
Date: Mon, 23 Nov 2009 15:37:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 23
References: <20091123185232.1423c56b.sfr@canb.auug.org.au>	<20091123111510.9b0c0714.randy.dunlap@oracle.com>	<200911240924.54675.rusty@rustcorp.com.au>	<4B0B1507.4060202@oracle.com> <20091124103641.abd7bd6b.sfr@canb.auug.org.au>
In-Reply-To: <20091124103641.abd7bd6b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B0B1D0F.0178:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Randy,
> 
> On Mon, 23 Nov 2009 15:04:39 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> I decided to check on linux-next (only checked x86_64 allmodconfig),
>> and viola:
>>
>> CONFIG_STAGING=y
>> CONFIG_STAGING_EXCLUDE_BUILD=y
>>
>> That is just too helpful.  :(
> 
> The Kconfig was deliberately done so that the all{no,yes,mod}config
> builds don't build the staging stuff.  You need to explictly ask for it.
> Otherwise I would spend all my time reporting/fixing errors and warnings
> in linux-next.
> 

no, you should just drop it after one build error.


-- 
~Randy
