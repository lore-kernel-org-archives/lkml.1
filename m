Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188Ab0AUVNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0AUVNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822Ab0AUVNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:13:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754705Ab0AUVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:13:49 -0500
Date: Thu, 21 Jan 2010 13:13:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Tilman Schmidt <tilman@imap.cc>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: Tree for January 21
Message-Id: <20100121131339.5e86dfef.akpm@linux-foundation.org>
In-Reply-To: <20100121165713.7b8a746d.sfr@canb.auug.org.au>
References: <20100121165713.7b8a746d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010 16:57:13 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

It includes this screwed up commit:

:commit e303d9eadc64907535a0a104afa5871d2b83275e
:Author:     Tilman Schmidt <tilman@imap.cc>
:AuthorDate: Thu Jan 14 23:18:41 2010 +0100
:Commit:     Jesse Barnes <jbarnes@virtuousgeek.org>
:CommitDate: Fri Jan 15 10:08:07 2010 -0800
:
:    PCI/ISDN: push deprecated pci_find_device() function to last user (isdn)
:    
:    The ISDN4Linux HiSax driver family contains the last remaining users of
:    the deprecated pci_find_device() function. This patch creates a private
:    copy of that function in HiSax, and removes the now unused global
:    function together with its controlling configuration option,
:    CONFIG_PCI_LEGACY.
:    
:    Signed-off-by: Tilman Schmidt <tilman@imap.cc>
:    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

It adds a bunch of files which are compile-time generated:

include/linux/autoconf.h
include/linux/bounds.h
include/linux/compile.h
include/linux/utsrelease.h

