Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZDUL4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZDUL4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 07:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZDULzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 07:55:54 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44609 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZDULzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 07:55:54 -0400
Message-ID: <49EDB449.4010201@s5r6.in-berlin.de>
Date: Tue, 21 Apr 2009 13:55:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jason Baron <jbaron@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "PRINTK_DEBUG"?
References: <alpine.LFD.2.00.0904191523270.11432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904191523270.11432@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   lib/Kconfig.debug:      select PRINTK_DEBUG
> 
> should that perhaps refer to "DYNAMIC_PRINTK_DEBUG"?  since there is
> no such thing as a PRINTK_DEBUG Kconfig variable.

Looks like a rudiment from an earlier version of Jason's "driver core:
basic infrastructure for per-module dynamic debug messages",
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=346e15beb5343c2eb8216d820f2ed8f150822b08
Search an LKML archive for '+#ifdef CONFIG_PRINTK_DEBUG'.

Jason, should it be deleted or replaced by something?
-- 
Stefan Richter
-=====-==--= -=-- =-=-=
http://arcgraph.de/sr/
