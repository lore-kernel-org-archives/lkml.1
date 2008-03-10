Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYCJRsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYCJRsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYCJRr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:47:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48100 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYCJRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:47:56 -0400
Date: Mon, 10 Mar 2008 10:46:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lwoodman@redhat.com
Subject: Re: [PATCH] sysrq show-all-cpus
Message-Id: <20080310104628.b70af419.randy.dunlap@oracle.com>
In-Reply-To: <20080310133242.0ab69084@bree.surriel.com>
References: <20080310133242.0ab69084@bree.surriel.com>
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

On Mon, 10 Mar 2008 13:32:42 -0400 Rik van Riel wrote:

> SysRQ-P is not always useful on SMP systems, since it usually ends up showing the
> backtrace of a CPU that is doing just fine, instead of the backtrace of the CPU
> that is having problems.
> 
> This patch adds SysRQ show-all-cpus(L), which shows the backtrace of every active
> CPU in the system.  It skips idle CPUs because some SMP systems are just too large
> and we already know what the backtrace of the idle task looks like.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Hi,
Please update Documentation/sysrq.txt also.

---
~Randy
