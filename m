Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYIXWh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYIXWh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYIXWgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:36:51 -0400
Received: from styx.suse.cz ([82.119.242.94]:41111 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751151AbYIXWgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:36:50 -0400
Date: Thu, 25 Sep 2008 00:37:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kyle McMartin <kyle@mcmartin.ca>
cc: David Miller <davem@davemloft.net>, airlied@gmail.com,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <20080924191022.GC2591@phobos.i.cabal.ca>
Message-ID: <alpine.LNX.1.10.0809250036090.4671@pegasus.suse.cz>
References: <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz> <20080923.211215.193696086.davem@davemloft.net> <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com> <20080924.003638.71148740.davem@davemloft.net>
 <20080924191022.GC2591@phobos.i.cabal.ca>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Kyle McMartin wrote:

> I've been working on a patch to detect (using a timer and checking at
>  up/down) whether or not the flash has been corrupted, and, if it is
> rewrite it with the saved good copy (which obviously only helps if
> it's the same boot.)

Thanks, looks interesting e1000e hack that might possibly be of some help.

BUT! please have a look at

	http://lkml.org/lkml/2008/9/24/133

Looks like this device got a lot of 0xff written somewhere in its config 
space, right? But it isn't Intel card at all.

-- 
Jiri Kosina
SUSE Labs
