Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYFIQjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYFIQjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbYFIQjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:39:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46136 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYFIQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:39:44 -0400
Message-ID: <484D5CCB.5020709@firstfloor.org>
Date: Mon, 09 Jun 2008 18:39:39 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Bernhard Walle <bwalle@suse.de>
CC: Vivek Goyal <vgoyal@redhat.com>, Johannes Weiner <hannes@saeurebad.de>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       anderson@redhat.com, Amul Shah <amul.shah@unisys.com>
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
References: <20080608134628.757299158@halley.suse.de>	<20080608134629.743220278@halley.suse.de>	<87bq2bmvro.fsf@saeurebad.de>	<20080609132207.GC3542@redhat.com> <20080609182341.00d6e746@halley.suse.de>
In-Reply-To: <20080609182341.00d6e746@halley.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> * Vivek Goyal [2008-06-09 09:22]:
>> Kdump first kernel always tries to reserve just physical RAM and nothing
>> else. So I am not sure what does above code do. Try to reserve a memory
>> which is not RAM but is in the region less than highest mapped entity and
>> in that case return silently without any warning. In what case do we
>> exercise this path?
> 
> I don't know. That code has been introduced in 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5e58a02a8f6a7a1c9ae41f39286bcd3aea0d6f24
> 
> Ccing Andi.
> 
> IMO we should not print any warning in that function, leaving the error
> handling to the caller.

Don't remember the details. Perhaps Amul does (cc'ed)

-Andi

