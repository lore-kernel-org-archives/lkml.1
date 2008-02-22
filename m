Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbYBVJvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbYBVJvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYBVJvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:51:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41192 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYBVJvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:51:23 -0500
Message-ID: <47BE9B80.2090808@firstfloor.org>
Date: Fri, 22 Feb 2008 10:53:04 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: trenn@suse.de
CC: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>,
       Christoph Hellwig <hch@lst.de>, dsdt@gaugusch.at, len.brown@intel.com,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Subject: Re: acpi dsts loading and populate_rootfs
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de>	 <47AEE6D1.4070402@tremplin-utc.net> <20080212053730.GA15347@lst.de>	 <47BDC705.6090902@tremplin-utc.net> <1203670297.4995.12.camel@queen.suse.de>
In-Reply-To: <1203670297.4995.12.camel@queen.suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Which is probably a good idea.
> AFAIK Numa, possibly Apic tables must be available quite early.

NUMA setup does not use the DSDT, but separate special tables
(SRAT/SLIT). It also doesn't require the ACPI interpreter, these
are all simple static tables.

-Andi

