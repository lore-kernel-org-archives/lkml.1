Return-Path: <linux-kernel-owner+w=401wt.eu-S1765989AbXHYSCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765989AbXHYSCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 14:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXHYSCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 14:02:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54238 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbXHYSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 14:02:08 -0400
Date: Sat, 25 Aug 2007 11:01:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Willy Tarreau <wtarreau@hera.kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 2.6.20.17
Message-Id: <20070825110148.5fd59272.randy.dunlap@oracle.com>
In-Reply-To: <20070825153810.GA32619@hera.kernel.org>
References: <20070825153810.GA32619@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007 15:38:10 +0000 Willy Tarreau wrote:

> 
> I've just released Linux 2.6.20.17.
> 
> As a reminder, it fixes these 3 security issues :
>   CVE-2007-3105
>   CVE-2007-3848
>   CVE-2007-3851
> 
> I'll also be replying to this message with a copy of the patch between
> 2.6.20.16 and 2.6.20.17.
> 
> The patch and changelog will appear soon at the following locations:
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.17.bz2
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.17
> 
> Git repository:
>    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
>   http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
> 
> Git repository through the gitweb interface:
>   http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git

I'm getting build errors:

x86_64 allyesconfig, allmodconfig:

drivers/ata/pata_atiixp.c:286: error: 'PCI_DEVICE_ID_ATI_IXP700_IDE' undeclared here (not in a function)
net/bluetooth/rfcomm/tty.c:275: error: 'struct rfcomm_dev' has no member named 'tty_dev'
net/bluetooth/rfcomm/tty.c:278: error: 'struct rfcomm_dev' has no member named 'tty_dev'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
