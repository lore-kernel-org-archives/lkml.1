Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYHODLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYHODLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYHODLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:11:34 -0400
Received: from mga05.intel.com ([192.55.52.89]:14131 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbYHODLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:11:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,213,1217833200"; 
   d="scan'208";a="606961008"
Message-ID: <48A4F3DA.9030200@linux.intel.com>
Date: Fri, 15 Aug 2008 05:11:22 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>	 <20080814083828.d10e126d.randy.dunlap@oracle.com>	 <20080814154456.GA26388@kroah.com>  <48A4F05B.9050309@linux.intel.com> <1218769772.3209.46.camel@rzhang-dt>
In-Reply-To: <1218769772.3209.46.camel@rzhang-dt>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> It looks more like the high level code that sets up these parameters
>> broke somehow and starts registering these twice and now ACPI is the
>> first one to hit it (maybe because it starts with 'a' :-). 
> Perhaps we could try "acpi=off" and see if it still happens.

I doubt that would help because module_param()s are always registered
even with acpi=off. They are not really processed by ACPI, but by
kernel/params.c

-Andi

