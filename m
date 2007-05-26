Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbXEZQB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbXEZQB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXEZQBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:01:22 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbXEZQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:01:21 -0400
Date: Sat, 26 May 2007 09:01:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070526090117.dda72286.akpm@linux-foundation.org>
In-Reply-To: <46585953.80200@imap.cc>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46585953.80200@imap.cc>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007 17:59:15 +0200 Tilman Schmidt <tilman@imap.cc> wrote:

> Am 23.05.2007 09:42 schrieb Andrew Morton:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
> 
> This breaks network initialization on my SuSE 10.0 box once
> again although I compiled with CONFIG_SYSFS_DEPRECATED=y.
> Acquisition of the IP address via DHCP times out.
> Manual start (rcnetwork restart) doesn't help either.
> 
> I'll start bisecting as soon as the machine is free.

Thanks.  I think others have seen similar things and it was attributed to
driver-core-check-return-code-of-sysfs_create_link.patch.
