Return-Path: <linux-kernel-owner+w=401wt.eu-S933048AbYEVJzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbYEVJzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYEVJyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:54:51 -0400
Received: from main.gmane.org ([80.91.229.2]:49348 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbYEVJyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:54:50 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [BISECTED] linux-next-20080519 does not boot on x86 (ACPI)
Date: Thu, 22 May 2008 10:54:33 +0100
Message-ID: <g13fsp$uv4$1@ger.gmane.org>
References: <g0s6pv$va4$1@ger.gmane.org> <g11l0c$jji$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<posted & mailed>

Sitsofe Wheeler wrote:

> <posted & mailed>
> 
> Sitsofe Wheeler wrote:
> 
>> While trying to boot this kernel the kernel seems to be going well until
>> it comes to time to mount disks at which point it starts going very slow.
>> It doesn't respond to the keyboard (caps lock does not work), sysrq is
>> inoperable and the ATA tests timeout and over the course of minutes start
>> negotiating slower speeds. Using nmi_watchdog=1 or nmi_watchdog=2 does
>> not make any difference. next-20080516 booted correctly.
>> 
>> Config is downloadable from http://sucs.org/~sits/test/config-20080519 .
> 
> OK I've finally bisected this down to the following commit:
> commit 86a2e1a7ec8c6363e502ac8ccf5fe50dd46b39c2

Hmm. Looks like I spoke too soon. This problem doesn't occur with
next-20080522 .

-- 
Sitsofe

