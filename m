Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXF3Szd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXF3Szd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 14:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXF3SzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 14:55:25 -0400
Received: from ns2.suse.de ([195.135.220.15]:48056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbXF3SzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 14:55:25 -0400
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Robert Hancock <hancockr@shaw.ca>, Zan Lynx <zlynx@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: 2.6.22-rc6-mm1 Intel DMAR crash on AMD x86_64
References: <46845943.7050005@shaw.ca>
	<FC1D1B23302A22499C60C967336B2AE0016F7529@pdsmsx411.ccr.corp.intel.com>
	<20070629152858.GA27995@linux-os.sc.intel.com>
	<20070629162343.GD27698@rhun.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 Jun 2007 21:50:47 +0200
In-Reply-To: <20070629162343.GD27698@rhun.ibm.com>
Message-ID: <p73645543xk.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda <muli@il.ibm.com> writes:
> 
> The convention is to print a KERN_DEBUG message if hardware is not
> found when probing it, otherwise the boot messages become cluttered
> with lots of "$FOO not found".

No the convention is to print no message at all when nothing is found
Some drivers fail this, but they're bad examples.

-Andi
