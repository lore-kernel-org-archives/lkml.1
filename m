Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYIVSUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYIVSUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYIVSUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:20:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12434 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbYIVSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:20:38 -0400
Date: Mon, 22 Sep 2008 11:19:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-09-22-01-36 uploaded (profiling)
Message-Id: <20080922111956.fd6dcb20.randy.dunlap@oracle.com>
In-Reply-To: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
References: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 01:38:58 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-09-22-01-36 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.27-rc7:

kernel/built-in.o: In function `profiling_store':
ksysfs.c:(.text+0x1b9b1): undefined reference to `create_proc_profile'
make[1]: *** [.tmp_vmlinux1] Error 1


when CONFIG_PROC_FS=n.


---
~Randy
