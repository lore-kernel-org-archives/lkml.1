Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXJ0DV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXJ0DV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 23:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbXJ0DVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 23:21:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37282 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXJ0DVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 23:21:46 -0400
Date: Sat, 27 Oct 2007 04:21:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86 patch] Fix UML init/do_mounts.h build failure
Message-ID: <20071027032133.GK8181@ftp.linux.org.uk>
References: <20071025113630.27728.12797.sendpatchset@balbir-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025113630.27728.12797.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 05:06:30PM +0530, Balbir Singh wrote:
> 
> 
> Fix stat.h to not use __i386__, but use BITS_PER_LONG. The UML architecture
> in turn includes this file. This helps resolve one build failure in the
> current UML code

NACK
