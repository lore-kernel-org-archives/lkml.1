Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300Ab0ATQEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0ATQEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147Ab0ATQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:04:12 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:59563 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0ATQEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:04:11 -0500
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 11:04:11 EST
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Clark Williams <williams@redhat.com>
Subject: Re: RFC: NUMA modifications to cyclictest
Date: Wed, 20 Jan 2010 18:54:45 +0300
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Carsten Emde <ce@ceag.ch>,
       John Kacur <jkacur@redhat.com>
References: <20100119171439.24726f2e@torg> <alpine.LFD.2.00.1001200741000.2906@localhost.localdomain> <20100120073734.4be7a52b@torg>
In-Reply-To: <20100120073734.4be7a52b@torg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001201854.46935@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The other idea I toyed with was dynamic loading of libnuma so there's
> not an install dependency for the libnuma package with the rt-tests
> package. I only use five functions from libnuma, so that's not too bad
> a set of function pointers to manage. Hmmm, that probably won't work
> very well, since I'll still have to include numa.h. Sigh...

It's an overkill.

We are not talking about use package to be installed into millions of 
systems in binary form.

rt-tests are used by developers; developers may compile those with needed 
options.

Nikita
