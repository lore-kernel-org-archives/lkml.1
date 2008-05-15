Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbYEONjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbYEONjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYEONi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:38:57 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:46107 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYEONi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:38:57 -0400
Date: Thu, 15 May 2008 15:38:55 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: abhiruchi.g@vaultinfo.com
Cc: linux-kernel@vger.kernel.org,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       kernel-testers <kernel-testers@vger.kernel.org>
Subject: Re: MIPS kernel hangs: Warning: unable to open an initial console.
	/sbin/init
Message-ID: <20080515133855.GA20300@roarinelk.homelinux.net>
References: <55815.192.168.1.71.1210856139.webmail@192.168.1.71>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55815.192.168.1.71.1210856139.webmail@192.168.1.71>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 08:55:39AM -0400, abhiruchi.g@vaultinfo.com wrote:
> Hi,
> 
> My kernel hangs by initializing the system. My target is Alchemy DB1200. I use crosstool-ng to build MIPS cross toolchain and ptxdist to build ext2 filesystem.
> kernel version:linux-2.6.22

Try and add "console=ttyS0,115200" to the kernel commandline (either in
yamon or kernel config).


	Manuel Lauss
