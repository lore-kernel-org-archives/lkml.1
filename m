Return-Path: <linux-kernel-owner+w=401wt.eu-S965365AbXDBK3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965365AbXDBK3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965396AbXDBK3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:29:33 -0400
Received: from www.osadl.org ([213.239.205.134]:48779 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965365AbXDBK3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:29:33 -0400
Subject: Re: Clockevents: one-shoot mode is never enabled if local apic
	timer is disabled
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200704021323.45585.maximlevitsky@gmail.com>
References: <200704021157.03368.maximlevitsky@gmail.com>
	 <1175506484.28263.101.camel@localhost.localdomain>
	 <200704021323.45585.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 12:29:40 +0200
Message-Id: <1175509780.28263.107.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 13:23 +0300, Maxim Levitsky wrote:
> Hi, 
> 
> Fortunately on my system lapic timer works.
> But then tick_broadcast_switch_to_oneshot is redundant, isn't it? 

No, it's necessary for the systems where the local APIC timer stops in
C3(C2), as we do not know this at the point where we setup the local
APIC. 

	tglx



