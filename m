Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZANSMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZANSMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZANSMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:12:15 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:24089 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZANSMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:12:14 -0500
Message-ID: <496E2AEE.3060709@oracle.com>
Date: Wed, 14 Jan 2009 10:11:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUILD-FAILURE] next-20090114 - drivers/staging/meilhaus
References: <20090114165002.3bbe49d7.sfr@canb.auug.org.au> <20090114180024.GB4796@linux.vnet.ibm.com> <20090114180403.GA16974@suse.de>
In-Reply-To: <20090114180403.GA16974@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.496E2AF2.00EE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Jan 14, 2009 at 11:30:24PM +0530, Kamalesh Babulal wrote:
>> Hi Stephen,
>>
>> 	next-20090114 randconfig build on x86_64 machine fails,
>>
>>   LD      drivers/staging/meilhaus/built-in.o
>> drivers/staging/meilhaus/me1600.o: In function `cleanup_module':
>> (.exit.text+0x0): multiple definition of `cleanup_module'
>> drivers/staging/meilhaus/memain.o:memain.c:(.exit.text+0x0): first defined here
> 
> Yeah, a lot of these staging drivers can't handle being built into the
> kernel.
> 
> At first glance, I don't see a way to prevent this, is there some
> Kconfig option I can use to say, "this can only be a module or disabled,
> not build statically"?

	depends on m


-- 
~Randy
