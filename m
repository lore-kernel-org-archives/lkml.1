Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952Ab0AQOpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0AQOpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844Ab0AQOpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:45:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab0AQOpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:45:01 -0500
Date: Sun, 17 Jan 2010 16:44:11 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       riel@redhat.com, cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
Message-ID: <20100117144411.GI31692@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
 <1262700774-1808-5-git-send-email-gleb@redhat.com>
 <1263490267.4244.340.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263490267.4244.340.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 06:31:07PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-01-05 at 16:12 +0200, Gleb Natapov wrote:
> > Allow paravirtualized guest to do special handling for some page faults.
> > 
> > The patch adds one 'if' to do_page_fault() function. The call is patched
> > out when running on physical HW. I ran kernbech on the kernel with and
> > without that additional 'if' and result were rawly the same:
> 
> So why not program a different handler address for the #PF/#GP faults
> and avoid the if all together?
I would gladly use fault vector reserved by x86 architecture, but I am
not sure Intel will be happy about it.

--
			Gleb.
