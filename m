Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYEaHpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYEaHpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 03:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYEaHo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 03:44:59 -0400
Received: from main.gmane.org ([80.91.229.2]:33664 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYEaHo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 03:44:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] x86: nmi - fix incorrect NMI watchdog used by default
Date: Sat, 31 May 2008 08:42:06 +0100
Message-ID: <g1qvlh$3dv$1@ger.gmane.org>
References: <20080528190047.GE6910@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:

> The commit
> 
> commit 4b82b277707a39b97271439c475f186f63ec4692
> Author: Cyrill Gorcunov <gorcunov@gmail.com>
> Date:   Sat May 24 19:36:35 2008 +0400
> 
> set nmi_watchdog to NMI_IO_APIC as by default. This causes hangs on some
> machines with buggy watchdogs. Fix it - i.e. restore old behaviour.

Thanks for fixing this. Just for the record, the problem also seemed to
depend on the ACPI Video option. Removing that also stopped the problem...
However I can confirm that I don't have a boot hang with next-0530.

-- 
Sitsofe | http://sucs.org/~sits/

