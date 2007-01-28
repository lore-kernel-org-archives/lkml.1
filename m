Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbXA1UsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbXA1UsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 15:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXA1UsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 15:48:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59841 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbXA1UsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 15:48:07 -0500
Message-ID: <45BD0BDC.40205@garzik.org>
Date: Sun, 28 Jan 2007 15:47:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <greg@kroah.com>, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] MSI portability cleanups
References: <1169714047.65693.647693675533.qpush@cradle> <m1hcubq6re.fsf@ebiederm.dsl.xmission.com> <1170015805.26655.15.camel@localhost.localdomain>
In-Reply-To: <1170015805.26655.15.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
>> The only architecture problem that isn't solvable in this context is
>> the problem of supporting the crazy hypervisor on the ppc RTAS, which
>> asks us to drive the hardware but does not give us access to the
>> hardware registers.
> 
> So you are saying that we should use your model while admitting that it
> can't solve our problems...
> 
> I really don't understand why you seem so totally opposed to Michael's
> approach which definitely looks to me like the sane thing to do. Note
> that in the end, Michael's approach isn't -that- different from yours,
> just a bit more abstracted.


I think the high-level ops approach makes more sense.  It's more future 
proof, in addition to covering all existing implementations.

	Jeff


