Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYDFTsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYDFTsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 15:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYDFTsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 15:48:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:26112 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYDFTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 15:48:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=Po6llLVdeSeRDkG9t1K6v/CfhrFjfTe2rLCADkRLB4jAjH29g4I45UTnrISbpviEQ9zQIqxCFDyMD7uqYC/iYdsDLIFWUcbFHNCl6okHmTlz7PvQ/qhGyg5ZRo0bsFcuEhjrFSGqSa2quce7mBm9iuw8wXFZURKTNJZrWXUlrys=
Message-ID: <47F928FC.7000603@gmail.com>
Date: Sun, 06 Apr 2008 14:48:12 -0500
From: YM Yen <yminyen@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Hooking to APIC timer on SMP 32-bit X86 system
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I am looking for a way to program the APIC timer in a kernel module so 
that the module depends only on the hardware timer instead of the timer 
provided by the kernel. Programming the LVT is easy, however I can't 
find a way to have the Linux kernel to call my interrupt service routine 
in addition to smp_apic_timer_interrupt().

Is doing this even possible? There doesn't seem to be any sort of hook 
or notifier chain I can install a ISR to. Thanks in advance.

Regards,

YM
