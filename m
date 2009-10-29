Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZJ2T4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZJ2T4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZJ2T4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:56:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:34615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZJ2T4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:56:04 -0400
Message-ID: <4AE9F342.2090901@kernel.org>
Date: Thu, 29 Oct 2009 12:55:46 -0700
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
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org> <4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com> <4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org> <4AE897B4.9030206@kernel.org>	<m1eionia3y.fsf@fess.ebiederm.org> <4AE8A080.1040208@kernel.org>	<m1pr87cilf.fsf@fess.ebiederm.org> <4AE8BA1D.5030908@kernel.org>	<4AE8C4BF.8040306@kernel.org> <m1my3aboon.fsf@fess.ebiederm.org>	<4AE95A57.6050504@kernel.org> <m1zl7a9ped.fsf@fess.ebiederm.org>	<4AE9CA10.10302@kernel.org> <m1pr86x9qj.fsf@fess.ebiederm.org>
In-Reply-To: <m1pr86x9qj.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> If enough space is routed and we get accurate information I am certain
> that is fine.  I am still worried about the change in policy though.
> 
> Only rerouting things when there is a need gives us the best chance of
> working everywhere.  Freeing unused resources on hotplug ports before
> we plug in a device scares me, because we do something that should
> but doesn't we reallocate them.  If there is simply not enough room
> we can do something different.

sure.

will send out another version, only release those res that don't have big range to support children.

YH
