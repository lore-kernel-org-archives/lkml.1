Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYJCP4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYJCP4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYJCP4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:56:04 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:34944 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbYJCP4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:56:03 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression] Latest git has WARN_ON storm with e1000e driver
Date: Fri, 3 Oct 2008 17:55:55 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <200810031041.49350.borntraeger@de.ibm.com> <200810031720.53923.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031755.55931.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got an idea,


kernel_init does lock_kernel (which does preempt_disable).
The kernel_unlock is done in init_post. As far as I can see, this happens 
after the driver init calls.

Christian
