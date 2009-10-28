Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZJ1O6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZJ1O6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZJ1O6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:58:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:44150 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZJ1O6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:58:38 -0400
Message-ID: <4AE85C53.7020400@kernel.org>
Date: Wed, 28 Oct 2009 15:59:31 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu: allow pcpu_alloc() to be called with IRQs
 off
References: <alpine.LSU.2.00.0910271328340.19847@wotan.suse.de> <4AE6EDBF.7040905@kernel.org>
In-Reply-To: <4AE6EDBF.7040905@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment added why irqsave/restore are used in alloc path and queued in
percpu#for-linus.  I'll send pull request in a few hours.

Thanks.

--
tejun
