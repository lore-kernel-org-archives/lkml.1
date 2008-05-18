Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYERLWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYERLWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 07:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYERLWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 07:22:17 -0400
Received: from main.gmane.org ([80.91.229.2]:49477 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYERLWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 07:22:16 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [BUG] unable to handle kernel paging request in next-20080516
 (scsi_bus_uevent)
Date: Sun, 18 May 2008 11:22:06 +0000 (UTC)
Message-ID: <g0p3gu$3gh$1@ger.gmane.org>
References: <g0mkaf$i1r$1@ger.gmane.org>
	<20080518021423.3dcf0ddd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Cc: linux-scsi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008 02:14:23 -0700, Andrew Morton wrote:

> (cc's added)
> 
> On Sat, 17 May 2008 12:50:24 +0000 (UTC) Sitsofe Wheeler
> 
>> Sometimes when booting next-20080516 on Ubuntu Gutsy an oops then a
>> panic will occur. At first I thought it might be provoked by vga=0x164
>> but this does not appear to be the case and the issue is seemingly
>> random. I've hand transcribed the oops so there may be errors in it but
>> hopefully it will still help:
>> 
>> BUG: unable to handle kernel paging request at e6f17fac IP:
>> [<c02604d6>] scsi_bus_uevent+0x1/0x17 *pde = 2714b163 *pte = 26f17160
>> Oops: 0000 [#1] DEBUG_PAGEALLOC
>> last sysfs file:
>> 
> I thought we'd already fixed this?

Thanks to your tip off I've found that this bug is already in bugzilla 
(complete with the commit that caused the regression) - http://
bugzilla.kernel.org/show_bug.cgi?id=10711 . There's nothing there that 
says it has been fixed though. I'll look harder before reporting problems 
next time.

-- 
Sitsofe | http://sucs.org/~sits/

