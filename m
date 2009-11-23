Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZKWTQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZKWTQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZKWTQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:16:36 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:56277 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZKWTQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:16:35 -0500
Date: Mon, 23 Nov 2009 11:15:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       rusty@rustcorp.com.au
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 23
Message-Id: <20091123111510.9b0c0714.randy.dunlap@oracle.com>
In-Reply-To: <20091123185232.1423c56b.sfr@canb.auug.org.au>
References: <20091123185232.1423c56b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B0ADF8D.0003:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 18:52:32 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20091120:


Hey rr,

This patch "param\:remove-useless-writable-charp.patch" has several typos
that cause build errors in drivers/staging/.  I sent patches for these errors
to gregkh but he couldn't apply them.  Please build STAGING (drivers/staging/)
crap along with other build testing when you make changes.


drivers/staging/rtl8187se/r8180_core.c:
+module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
                                     ^^^^^

drivers/staging/rtl8192e/r8192E_core.c:
+module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
                                     ^^^^^
and
+		strcpt(ifname, "wlan%d");
                ^^^^^^


Thanks.
---
~Randy
