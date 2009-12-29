Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZL2UWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZL2UWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZL2UWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:22:42 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:18089 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZL2UWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:22:41 -0500
Date: Tue, 29 Dec 2009 11:50:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 29 (staging/winbond)
Message-Id: <20091229115020.b20adfdb.randy.dunlap@oracle.com>
In-Reply-To: <20091229112810.24b461c2.sfr@canb.auug.org.au>
References: <20091229112810.24b461c2.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B3A64FF.00AD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Dec 2009 11:28:10 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> This one has also not had the build testing *between* merges, but has had
> all the normal build testing at the end.There may be more unbisectable
> points in the tree then usual.
> 
> Changes since 20091228:
> 
> My fixes tree contains this origin tree build fix:
> 
> 	kfifo: include linux/fifo.h in libsrp.h for definition of stuct kfifo
> 
> The net tree gained a conflict against the wireless-current tree.


drivers/staging/winbond/wbusb.c:68: warning: 'struct ieee80211_if_init_conf' declared inside parameter list
drivers/staging/winbond/wbusb.c:68: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/staging/winbond/wbusb.c:72: error: dereferencing pointer to incomplete type
drivers/staging/winbond/wbusb.c:78: warning: 'struct ieee80211_if_init_conf' declared inside parameter list

I can't find this struct in the kernel tree.

---
~Randy
