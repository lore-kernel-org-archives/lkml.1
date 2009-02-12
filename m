Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbZBLMur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbZBLMur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbZBLMue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54445 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbZBLMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:33 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/9] x86: CMCI: Add support for Intel CMCI 
Date: Thu, 12 Feb 2009 13:49:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Intel CMCI (Corrected Machine Check Interrupt) is a new
feature on Nehalem CPUs. It allows the CPU to trigger
interrupts on corrected machine check events, which allows faster
reaction to them instead of with the traditional 
polling timer.

This is similar to the existing AMD threshold interrupt
feature. I'm reusing some code from this.

In addition it also provides for better handling of machine
check banks shared between CPUs. This is pretty common
on Nehalem class systems, where threads and cores share
some banks with each other.

The series applies on top of the earlier bugfixes
and cleanups series. 

Aimed for 2.6.30. Tested on 2.6.29-rc4, but also
applies to x86 tip as of today.

-Andi
