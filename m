Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYBQFcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYBQFcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYBQFco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:32:44 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:30028 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYBQFcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:32:43 -0500
Date: Sat, 16 Feb 2008 21:32:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com
Subject: Re: 2.6.25-rc2-mm1 (build failure)
Message-Id: <20080216213225.f5f71c35.randy.dunlap@oracle.com>
In-Reply-To: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/

When SMP=n, x86_64 build gets:

arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
(.text+0xfd7f): undefined reference to `setup_trampoline'
make[1]: *** [.tmp_vmlinux1] Error 1

---
~Randy
