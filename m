Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYDFUoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYDFUoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbYDFUoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:44:08 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52272 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYDFUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:44:07 -0400
Date: Sun, 06 Apr 2008 14:46:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Hooking to APIC timer on SMP 32-bit X86 system
In-reply-to: <fa.ORNHzXNKWJTtCts8OxkQgfojzSk@ifi.uio.no>
To: YM Yen <yminyen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <47F9368E.7070107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ORNHzXNKWJTtCts8OxkQgfojzSk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YM Yen wrote:
> hi,
> 
> I am looking for a way to program the APIC timer in a kernel module so 
> that the module depends only on the hardware timer instead of the timer 
> provided by the kernel. Programming the LVT is easy, however I can't 
> find a way to have the Linux kernel to call my interrupt service routine 
> in addition to smp_apic_timer_interrupt().
> 
> Is doing this even possible? There doesn't seem to be any sort of hook 
> or notifier chain I can install a ISR to. Thanks in advance.

It might be possible, but likely not easy and not recommended. Why is a 
kernel timer not sufficient for what you need?
