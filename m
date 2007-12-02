Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbXLBCEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbXLBCEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 21:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXLBCDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 21:03:51 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60070 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbXLBCDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 21:03:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: netdev@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: namespace support requires network modules to say "GPL"
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	<47515D39.9030900@rtr.ca> <20071201111736.297dd99a@freepuppy.rosehill>
	<20071201163035.321fd554@freepuppy.rosehill>
Date: Sat, 01 Dec 2007 19:02:37 -0700
In-Reply-To: <20071201163035.321fd554@freepuppy.rosehill> (Stephen Hemminger's
	message of "Sat, 1 Dec 2007 16:30:35 -0800")
Message-ID: <m1y7cd3lc2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@linux-foundation.org> writes:

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
> 2.6.24-rc3. Vmware and proprietary VPN software probably do not. Once again I
> don't
> give a damn, but the enterprise distro vendors certainly care.

It looks like someone found a work around for vmware.

As for proprietary VPN software, the one case that came of David Miller
said we had sufficient alternatives in the kernel that he didn't care.

We have to make a lot of changes to get the network namespaces
complete.  I don't have pity on any external code that breaks because
they won't let me at their code.

If it turns out the code that was broken was an unacknowledged
derivative work and it can't be fixed I have even less pity on
them.

Eric
