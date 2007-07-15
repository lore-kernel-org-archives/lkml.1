Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbXGOXoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbXGOXoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760919AbXGOXn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:43:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760438AbXGOXn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:43:58 -0400
Date: Sun, 15 Jul 2007 16:43:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL][RESEND] KVM Updates for 2.6.23-rc1
In-Reply-To: <11843929041758-git-send-email-avi@qumranet.com>
Message-ID: <alpine.LFD.0.999.0707151641560.20061@woody.linux-foundation.org>
References: <11843929041758-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Jul 2007, Avi Kivity wrote:
>
> Linus, please do your usual thing from the repository and branch at

It has code like

	+       /* Can deadlock when called with interrupts disabled */
	+       WARN_ON(irqs_disabled());
	+
	        /* prevent preemption and reschedule on another processor */
	        int me = get_cpu();

which is against the coding conventions (and shouldn't even compile 
cleanly - but maybe we don't have the "warn about C99 variable 
declarations" thng on?).

Please don't do that.

		Linus
