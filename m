Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYDSAVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYDSAVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 20:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYDSAVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 20:21:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51626 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbYDSAVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 20:21:41 -0400
Message-ID: <48093AF3.2080807@garzik.org>
Date: Fri, 18 Apr 2008 20:21:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       kernel@wantstofly.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <20080418164411.b1e1628d.akpm@linux-foundation.org>
In-Reply-To: <20080418164411.b1e1628d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 18 Apr 2008 19:22:45 -0400 (EDT)
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Avoid confusion by /not/ passing an unused pointer to
>> arm_rtc_interrupt()
>>
>> This change's main purpose is to prepare for the patchset in
>> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
>> never-used 'irq' argument in each interrupt handler.
> 
> #irq-remove doesn't seem to be included in the #ALL branch which
> I'm grabbing?

I certainly welcome the exposure.......  but it would be a huge pain for 
you IMO because of the constant breakage.

	Jeff


