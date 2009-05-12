Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbZELVCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbZELVCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZELVCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:02:13 -0400
Received: from THUNK.ORG ([69.25.196.29]:34661 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbZELVCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:02:13 -0400
Date: Tue, 12 May 2009 17:01:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com, John Gilmore <gnu@toad.com>
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090512210154.GC23773@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Joseph Cihula <joseph.cihula@intel.com>,
	linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
	hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
	jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
	gang.wei@intel.com, shane.wang@intel.com,
	John Gilmore <gnu@toad.com>
References: <4A03B9C3.9090607@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03B9C3.9090607@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 09:49:07PM -0700, Joseph Cihula wrote:
> Linux support for Intel(R) Trusted Execution Technology.

It should be noted that one of the prime purposes of the Trusted
Execution Technology (TXT), aka LaGrande Technology is for DRM
enforcement systems that can be nearly uncrackable.

It can be used for other things, such as restricting who can look at
your medical records (basically, the same technology that prevents you
from breaking the DRM on say, a high-definition movie from Hollywood)
can also be used to enforced who can look at your certain records,
such as medical records in a highly secure and non-circumvental
fashion.

Ross Anderson was one of the first to write about these concerns, over
five years ago:

     http://www.cl.cam.ac.uk/~rja14/tcpa-faq.html

It's interesting that his 2003 document was able to predict the
emergence of the LaGrande Technology (see question 15 in the above
FAQ).

So we should expect a certain amount of controversy and people
lobbying to resist the acceptance of this patch.

Regards,

						- Ted
