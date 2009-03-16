Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbZCPJ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbZCPJ55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760725AbZCPJwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:52:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58387 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760716AbZCPJwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:52:31 -0400
X-Sasl-enc: Y8PvajL4ExoKaSCi6Od8e5ZvzqTd+s0t0x9VFRifhrhj 1237197148
Message-ID: <49BE215F.7040307@ladisch.de>
Date: Mon, 16 Mar 2009 10:52:31 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
Subject: Re: [Patch] Fix the possibility of insane return value of hpet_calibrate()
 against SMI.
References: <20090313134846.24B6.E1E9C6FF@jp.fujitsu.com> <7d1d9c250903151256l36586764wfbd5e2578a45663c@mail.gmail.com> <20090316111300.7CE5.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20090316111300.7CE5.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
> > I've no sense of feel for how long each calibration run would take.
> > Would doing it 5 times show up as a significant increase in the boot
> > time for those that care about boot time being as quick as possible?
> 
> Hmm. The loop times is trade off against reliable value....
> Though SMI is rare interruption, I don't know how frequent
> hypervisor's switch is.

Could you, just for testing, run the calibration five thousand times or
so instead of five times, and count how often you get insane values?
(And how much delay does such an SMI add?)

> Each calibration of this has 1 milli second.
> Do you think 5 msec is too long?

This shouldn't matter when booting.  Anyway, I think it's possible to
increase TICK_CALIBRATE without losing too much accuracy.


Best regards,
Clemens
