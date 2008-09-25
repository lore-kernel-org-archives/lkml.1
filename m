Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYIYSkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYIYSkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYIYSkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:40:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYIYSkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:40:40 -0400
Message-ID: <48DBDAF1.3050708@zytor.com>
Date: Thu, 25 Sep 2008 11:39:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Kyle McMartin <kyle@mcmartin.ca>, David Miller <davem@davemloft.net>,
       airlied@gmail.com, jeffrey.t.kirsher@intel.com, david.vrabel@csr.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz> <20080923.211215.193696086.davem@davemloft.net> <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com> <20080924.003638.71148740.davem@davemloft.net> <20080924191022.GC2591@phobos.i.cabal.ca> <alpine.LNX.1.10.0809250036090.4671@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809250036090.4671@pegasus.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 24 Sep 2008, Kyle McMartin wrote:
> 
>> I've been working on a patch to detect (using a timer and checking at
>>  up/down) whether or not the flash has been corrupted, and, if it is
>> rewrite it with the saved good copy (which obviously only helps if
>> it's the same boot.)
> 
> Thanks, looks interesting e1000e hack that might possibly be of some help.
> 
> BUT! please have a look at
> 
> 	http://lkml.org/lkml/2008/9/24/133
> 
> Looks like this device got a lot of 0xff written somewhere in its config 
> space, right? But it isn't Intel card at all.
> 

That looks like the device disappeared completely.

	-hpa
