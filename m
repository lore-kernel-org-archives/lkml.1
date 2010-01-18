Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476Ab0ARIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0ARIvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423Ab0ARIvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:51:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab0ARIvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:51:16 -0500
Date: Mon, 18 Jan 2010 10:50:22 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
Message-ID: <20100118085022.GA30698@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
 <1262700774-1808-5-git-send-email-gleb@redhat.com>
 <1263490267.4244.340.camel@laptop>
 <20100117144411.GI31692@redhat.com>
 <4B541D08.9040802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B541D08.9040802@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 12:34:16AM -0800, H. Peter Anvin wrote:
> On 01/17/2010 06:44 AM, Gleb Natapov wrote:
> >On Thu, Jan 14, 2010 at 06:31:07PM +0100, Peter Zijlstra wrote:
> >>On Tue, 2010-01-05 at 16:12 +0200, Gleb Natapov wrote:
> >>>Allow paravirtualized guest to do special handling for some page faults.
> >>>
> >>>The patch adds one 'if' to do_page_fault() function. The call is patched
> >>>out when running on physical HW. I ran kernbech on the kernel with and
> >>>without that additional 'if' and result were rawly the same:
> >>
> >>So why not program a different handler address for the #PF/#GP faults
> >>and avoid the if all together?
> >I would gladly use fault vector reserved by x86 architecture, but I am
> >not sure Intel will be happy about it.
> >
> 
> That's what it's there for... see Peter Z.'s response.
> 
Do you mean I can use one of exception vectors reserved by Intel
(20-31)? What Peter Z says is that I can register my own handler for
#PF and avoid the 'if' in non PV case as far as I understand him.

--
			Gleb.
