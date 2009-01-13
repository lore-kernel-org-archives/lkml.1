Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZAMVcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZAMVcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZAMVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:32:10 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:51079 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZAMVcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:32:09 -0500
Message-ID: <496D083C.3060109@oracle.com>
Date: Tue, 13 Jan 2009 13:31:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       swhiteho@redhat.com, cluster-devel@redhat.com
Subject: Re: linux-next: Tree for January 13 (gfs2 build error)
References: <20090113175145.cdfa9c6a.sfr@canb.auug.org.au>
In-Reply-To: <20090113175145.cdfa9c6a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.496D0840.0071:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Today, I merged the updates to Linus' and the powerpc trees that happened
> during the day.
> 
> Changes since 20090112:


When CONFIG_FILE_LOCKING=n, this construct:

	.setlease	= generic_setlease,

refers to a macro, not a function, so the address of it
fails with:

fs/gfs2/ops_file.c:746: error: 'generic_
setlease' undeclared here (not in a function)

-- 
~Randy
