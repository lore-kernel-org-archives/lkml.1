Return-Path: <linux-kernel-owner+w=401wt.eu-S968855AbXG3VwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968855AbXG3VwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967986AbXG3Vv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:51:59 -0400
Received: from main.gmane.org ([80.91.229.2]:42957 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967979AbXG3Vv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:51:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Steven <hairpinblue@yahoo.com>
Subject: Re: [2.6.23-rc1 REGRESSION] ThinkPad T42 poweroff failure by "PM:
 Introduce pm_power_off_prepare"
Date: Mon, 30 Jul 2007 21:51:42 +0000 (UTC)
Message-ID: <f8lmhe$o10$1@sea.gmane.org>
References: <200707251446.56809.rjw@sisk.pl>
	<200707261412.33839.rjw@sisk.pl>
	<20070726.080624.94043434.yoshfuji@linux-ipv6.org>
	<200707261629.55741.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: rrcs-66-27-48-50.west.biz.rr.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 16:29:55 +0200, Rafael J. Wysocki wrote:

> OK, so here it goes again with a changelog:
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Generally, sysdev_shutdown() should be called after the ACPI preparation
> for powering the system off.  To make it happen, we can separate
> sysdev_shutdown() from device_shutdown() and call it directly wherever
> necessary.

Has this patch become part of the official git tree (git://git.kernel.org/
pub/scm/linux/kernel/git/torvalds/linux-2.6.git)?  If not then are there 
plans to make it part of the official git tree?

