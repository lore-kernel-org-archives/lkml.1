Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYLPRl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYLPRl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYLPRlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:41:47 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:21487 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509AbYLPRlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:41:46 -0500
Message-ID: <4947E856.1040008@oracle.com>
Date: Tue, 16 Dec 2008 09:41:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm <akpm@linux-foundation.org>, npiggin@suse.de
Subject: Re: mmotm 2008-12-16-00-43 uploaded (fs)
References: <200812160847.mBG8lOrw019428@imap1.linux-foundation.org>
In-Reply-To: <200812160847.mBG8lOrw019428@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4947E849.014C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2008-12-16-00-43 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc8:
> 
> fs-symlink-write_begin-allocation-context-fix.patch

Nick,

fuse and reiser4 still use __grab_cache_page() although your patch
removed it:

build-r7257.out:/local/linsrc/tmp/mmotm-2008-1216-0043/fs/reiser4/plugin/file/file_conversi
on.c:689: error: implicit declaration of function '__grab_cache_page'
build-r7257.out:make[3]: *** [fs/reiser4/plugin/file/file_conversion.o] Error 1

build-r7248.out:/local/linsrc/tmp/mmotm-2008-1216-0043/fs/fuse/file.c:792: error: implicit declaration of function '__grab_cache_page'
build-r7248.out:make[3]: *** [fs/fuse/file.o] Error 1

~Randy

