Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbZHDWuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbZHDWuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933419AbZHDWux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:50:53 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:62631 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357AbZHDWuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:50:52 -0400
Date: Tue, 4 Aug 2009 15:50:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, Roland Dreier <rolandd@cisco.com>
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2009-08-04-14-22 uploaded (ummunotify)
Message-Id: <20090804155014.35d4597c.randy.dunlap@oracle.com>
In-Reply-To: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
References: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt012.oracle.com [141.146.116.21]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A78BB24.0006:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Aug 2009 14:25:09 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-08-04-14-22 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.31-rc5:


Seems odd to me, but I'm seeing:

ummunotify.c:(.text+0x8f217): undefined reference to `__get_user_X'

when building for i386.

The get_user() and put_user() in ummunotify_exchange_features()
are correctly converted to __get_user_4() and __put_user_4(),
but the get_user() in ummunotify_unregister_region() becomes
__get_user_X()  [as seen in objdump output].

toolchain issue or something else??


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
