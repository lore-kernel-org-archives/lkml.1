Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbYG1U61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbYG1U61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYG1U6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:58:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYG1U6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:58:16 -0400
Date: Mon, 28 Jul 2008 16:50:45 -0400
From: Dave Jones <davej@redhat.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: [PATCH] x86: Coding style fixes to
	arch/x86/kernel/cpu/cpufreq/powernow-k6.c
Message-ID: <20080728205045.GB11581@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
	Arjan van de Ven <arjan@fenrus.demon.nl>
References: <20080728210816.4989c3f0@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728210816.4989c3f0@paolo-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 09:08:16PM +0200, Paolo Ciarrocchi wrote:
 > Ciao Ingo, all,
 > 
 > Before:
 > total: 11 errors, 15 warnings, 255 lines checked
 > 
 > After:
 > total: 0 errors, 6 warnings, 254 lines checked
 > 
 > paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/powernow-k6.o.*
 > 476932f5e1ffe365db9d1dfb3f860369  /tmp/powernow-k6.o.after
 > 476932f5e1ffe365db9d1dfb3f860369  /tmp/powernow-k6.o.before
 > 
 > Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>

I'll queue this up in cpufreq.git
  
 > -MODULE_AUTHOR ("Arjan van de Ven <arjanv@redhat.com>, Dave Jones <davej@codemonkey.org.uk>, Dominik Brodowski <linux@brodo.de>");
 > -MODULE_DESCRIPTION ("PowerNow! driver for AMD K6-2+ / K6-3+ processors.");
 > -MODULE_LICENSE ("GPL");
 > +MODULE_AUTHOR("Arjan van de Ven <arjanv@redhat.com>, Dave Jones <davej@codemonkey.org.uk>, Dominik Brodowski <linux@brodo.de>");
 > +MODULE_DESCRIPTION("PowerNow! driver for AMD K6-2+ / K6-3+ processors.");
 > +MODULE_LICENSE("GPL");

Incidentally, arjanv@redhat hasn't been correct in a while. 
Arjan, which preferred address do you want this changed to?
xircom_cb.c is also in need of a similar change.
(There are other instances of your old address, but those are the
 only user-visible ones)

	Dave

-- 
http://www.codemonkey.org.uk
