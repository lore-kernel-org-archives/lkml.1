Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYAWAXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYAWAXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYAWAXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:23:15 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:63198 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYAWAXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:23:14 -0500
Date: Tue, 22 Jan 2008 16:21:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Helmut Grohne <helmut@subdivi.de>
Cc: linux-kernel@vger.kernel.org, andrea@qumranet.com
Subject: Re: PROBLEM: SECCOMP documentation outdated in some arch/*/Kconfig
Message-Id: <20080122162156.e62e4285.randy.dunlap@oracle.com>
In-Reply-To: <20080122144156.GA29993@alf.mars>
References: <20080122144156.GA29993@alf.mars>
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

On Tue, 22 Jan 2008 15:41:58 +0100 Helmut Grohne wrote:

> Hi,
> 
> I didn't find out whom to report this bug to and thus report to
> linux-kernel@vger.kernel.org as described in
> http://kernel.org/pub/linux/docs/lkml/reporting-bugs.html.

Andrea cc-ed.

Helmut, would you care to make a patch that you think should be
applied to the current kernel source tree?


> I'm posting from outside, so please CC me.
> 
> [1] The description about seccomp is outdated in some arch/*/Kconfig
>     files.
> 
> [2] According to the source (2.6.23.14) seccomp is to be activated using
>     pcrtl. It was previously activated using a file /proc/<pid>/seccomp.
>     The Kconfig documentation (also displayed in menuconfig) does not
>     reflect this change and is thus wrong.
> 
> [3] seccomp documentation Kconfig
> 
> [4] 2.6.23.14, seems to also apply to git head:
>     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/x86/Kconfig;h=80b7ba4056dbbb566841c1e1cbef9475730fe199;hb=HEAD
> 
> [5] no oops
> 
> [6] less arch/x86_64/Kconfig
>     /SECCOMP
> 
> [7] Ask me again if you really think you need information about the
>     environment for a documentation bug.

---
~Randy
