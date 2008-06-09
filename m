Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYFIH05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYFIH05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 03:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYFIH0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 03:26:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755019AbYFIH0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 03:26:46 -0400
Date: Mon, 9 Jun 2008 00:25:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: [PATCH 0/6] gcov kernel support
Message-Id: <20080609002509.7782442e.akpm@linux-foundation.org>
In-Reply-To: <4843F6BF.9070409@de.ibm.com>
References: <4843F6BF.9070409@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 15:33:51 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> This is version #3 of the gcov kernel support patch set 

My build tree is now filled with dead symlinks, like

lrwxrwxrwx 1 akpm akpm 64 Jun  9 00:06 security/selinux/nlmsgtab.gcda -> /sys/kernel/debug/gcov/usr/src/25/security/selinux/nlmsgtab.gcda

Which causes (at least)

ctags: Warning: cannot open source file "security/selinux/ss/conditional.gcda" : No such file or directory
ctags: Warning: cannot open source file "security/selinux/netlink.gcda" : No such file or directory
ctags: Warning: cannot open source file "security/selinux/netlabel.gcda" : No such file or directory

and probably other thing which I haven't discovered yet.
