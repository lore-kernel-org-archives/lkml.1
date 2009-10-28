Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZJ1W0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZJ1W0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZJ1W0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:26:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:35180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZJ1W0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:26:53 -0400
Message-ID: <4AE8C520.6020100@kernel.org>
Date: Wed, 28 Oct 2009 15:26:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big range
 for pcie devices
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org> <4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com> <4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org> <4AE897B4.9030206@kernel.org>	<m1eionia3y.fsf@fess.ebiederm.org> <4AE8A080.1040208@kernel.org> <m1pr87cilf.fsf@fess.ebiederm.org> <4AE8BA1D.5030908@kernel.org> <4AE8C4BF.8040306@kernel.org>
In-Reply-To: <4AE8C4BF.8040306@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:

>>>
>>> Which means your patch would cause a regression in my setup.
>> ok, may need to compare new range size and old range size before clear it.
> 
> after closing look up the code, it looks it will not break your setup.
> 
> 1. before the patches:
> a. when master card is inserted, all bridge in that card will get assigned with min_size
> b. when new cards is inserted to those slots in master card, will get assigned in the bridge size.
> 
> 2. after the patches: v5
> a. booted up, all leaf bridge mmio get clearred.
> b. when master card is inserted, all bridge in that card will get assigned with min_size, and master bridge will be sum of them
> c. when new cards is inserted to those slots in master card, will get assigned in the bridge size.
> 
> can you check those two patches in your setup to verify it?
> http://patchwork.kernel.org/patch/56344/
> http://patchwork.kernel.org/patch/56343/

on top Jesse today's PCI tree.

YH
