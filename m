Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYIXQdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYIXQdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYIXQcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:32:55 -0400
Received: from styx.suse.cz ([82.119.242.94]:58684 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752211AbYIXQcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:32:54 -0400
Date: Wed, 24 Sep 2008 18:33:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Airlie <airlied@gmail.com>
cc: David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <21d7e9970809240216m4a93a339sb51a5928fcb5f6fb@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0809241829500.4671@pegasus.suse.cz>
References: <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>  <20080924.003638.71148740.davem@davemloft.net>  <21d7e9970809240159u6db747eex51892061846b2251@mail.gmail.com>  <20080924.020116.193720569.davem@davemloft.net>
 <21d7e9970809240216m4a93a339sb51a5928fcb5f6fb@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Dave Airlie wrote:

> Hopefully tglx can supply some traces, I think getting an interrupt 
> during device startup can possibly access the nvram
> http://www.tglx.de/~tglx/wtf2.txt
> seems to suggest bad things could happen.

Actually another user has just reported [1] that his e1000e card got 
screwed up exactly at the point when the installer was probing the X 
configuration. So this really seems a lot like some lethal interaction 
between intel graphics and the network card.

Dave (Airlie, too many Daves on CC here really), do you by any chance see 
any recent change in kernel intel graphic parts of DRM be causing this 
breakage?

[1] https://bugzilla.novell.com/show_bug.cgi?id=425480#c69

-- 
Jiri Kosina
SUSE Labs
