Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbXLBDeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbXLBDeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 22:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbXLBDeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 22:34:12 -0500
Received: from rtr.ca ([76.10.145.34]:2317 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbXLBDeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 22:34:11 -0500
Message-ID: <475227B1.2060802@rtr.ca>
Date: Sat, 01 Dec 2007 22:34:09 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: namespace support requires network modules to say "GPL"
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>	<47515D39.9030900@rtr.ca>	<20071201111736.297dd99a@freepuppy.rosehill> <20071201163035.321fd554@freepuppy.rosehill>
In-Reply-To: <20071201163035.321fd554@freepuppy.rosehill>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Sat, 1 Dec 2007 11:17:36 -0800
> Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> 
>> Then init_net needs to be not GPL limited. Sorry, we need to allow
>> non GPL network drivers.  There is a fine line between keeping the
>> binary seething masses from accessing random kernel functions, and allowing
>> reasonable (but still non GPL) things like ndiswrapper to use network
>> device interface.
>>
> I spoke too soon earlier, ndiswrapper builds and loads against current
> 2.6.24-rc3. Vmware and proprietary VPN software probably do not. Once again I don't
> give a damn, but the enterprise distro vendors certainly care.
...

Naw, enterprise (or any other) distro vendors shouldn't have any issues here,
since they can just patch their kernels around any issues.

But it looks like Eric has this one thought out well enough.

Cheers

