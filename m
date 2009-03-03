Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZCCCBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZCCCBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 21:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZCCCBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 21:01:15 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:32010 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZCCCBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 21:01:14 -0500
Message-ID: <49AC8F98.10101@oracle.com>
Date: Mon, 02 Mar 2009 18:02:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-03-02-17-09 uploaded
References: <200903030109.n2319UeR010057@imap1.linux-foundation.org>
In-Reply-To: <200903030109.n2319UeR010057@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49AC8F40.00F7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-03-02-17-09 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.29-rc6:


> relay-fix-for-possible-loss-corruption-of-produced-subbufs.patch


diffstat for this patch says:

 kernel/relay.c      |    8 
 kernel/relay.c.orig | 1406 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1411 insertions(+), 3 deletions(-)


and quilt stops applying the series file when it has this error:

Applying patch relay-fix-for-possible-loss-corruption-of-produced-subbufs.patch
patching file kernel/relay.c
The next patch would create the file kernel/relay.c.orig,
which already exists!  Applying it anyway.
patching file kernel/relay.c.orig
[31mPatch attempted to create file kernel/relay.c.orig, which already exists.[00m
[31mHunk #1 FAILED at 1.[00m
[31m1 out of 1 hunk FAILED -- rejects in file kernel/relay.c.orig[00m
Patch relay-fix-for-possible-loss-corruption-of-produced-subbufs.patch does not apply (enforce with -f)
-- 
~Randy
