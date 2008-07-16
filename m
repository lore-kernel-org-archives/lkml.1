Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYGPT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYGPT2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYGPT2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:28:08 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:59005 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbYGPT2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:28:07 -0400
Date: Wed, 16 Jul 2008 21:28:03 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: BIOS-controlled FN keys works only with "acpi={off | ht}" on
 Samsung P500
Message-ID: <20080716212803.20c061a9@paolo-laptop>
In-Reply-To: <1216082997.1617.87.camel@rzhang-dt>
References: <20080714213755.7e892550@paolo-laptop>
	<1216082997.1617.87.camel@rzhang-dt>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 08:49:57 +0800
Zhang Rui <rui.zhang@intel.com> wrote:

> > on this laptop, Samsung NP-P500Y, some function keys are
> > BIOS-controlled (they work before Linux boots).
> > 
> > As soon as Linux boots they stop working. Trying some boot options
> > I've found that "acpi=off" makes them work and the less drastic
> > "acpi=ht" works too.
> > 
> > I'm mostly interested in brightness adjusting... and since both
> > xbacklight and radeontool fail I've to use "acpi=ht".
> 
> Please file a bug report at
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
> and attach the dmesg, acpidump output.
> 
> Please run "grep . /sys/firmware/acpi/interrupts/*" both before and
> after pressing the brightness hotkey and attach the test result as
> well.

done:
http://bugzilla.kernel.org/show_bug.cgi?id=11102


Thanks,
Paolo
