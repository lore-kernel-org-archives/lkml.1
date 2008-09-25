Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYIYAc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYIYAc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYIYAcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:32:20 -0400
Received: from styx.suse.cz ([82.119.242.94]:44818 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752206AbYIYAcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:32:20 -0400
Date: Thu, 25 Sep 2008 02:33:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       airlied@gmail.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jesse.brandeburg@intel.com, Karsten Keil <kkeil@suse.de>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <200809241726.58628.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LNX.1.10.0809250230000.4671@pegasus.suse.cz>
References: <20080923.150722.141587696.davem@davemloft.net> <20080923.211215.193696086.davem@davemloft.net> <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz> <200809241726.58628.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Jesse Barnes wrote:

> That said, adding a check to the x86 code would be a good thing to do; 
> I'll hack up a patch tomorrow unless someone beats me to it.

The problem here is that what we desperately need first is a method to 
restore the original EEPROM contents after it gets corrupted (David Airlie 
has, sadly, apparently bricked his notebook while trying to do so). 
Without this, we can put a lot of debugging/protecting patches into the 
kernel, but we won't be able to succesfully verify anything, because 
testing wouldn't be possible.

Added Jesse and Karsten to CC, as they are working on such a tool right 
now, as far as I know.

-- 
Jiri Kosina
SUSE Labs
