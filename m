Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbYLAEte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbYLAEte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 23:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYLAEtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 23:49:25 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:37184 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYLAEtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 23:49:24 -0500
Message-ID: <49336CBC.5090706@oracle.com>
Date: Sun, 30 Nov 2008 20:49:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Len Brown <len.brown@intel.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH] x86: create drivers/x86/ from drivers/misc/
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au> <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au> <alpine.LFD.2.00.0811281649001.24773@localhost.localdomain> <alpine.LFD.2.00.0811281702570.24773@localhost.localdomain> <alpine.LFD.2.00.0811281706540.24773@localhost.localdomain> <20081128223533.GA5175@uranus.ravnborg.org> <alpine.LFD.2.00.0811281819070.24773@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0811281819070.24773@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49336CC0.0025:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> 
>> You move 12 files but delete 11 lines.
> 
> obj-$(CONFIG_TC1100_WMI)        += tc1100-wmi.o
> 
> was left behind by mistake.

Yes, that caused the build error that was the original posting
for this thread.

~Randy

