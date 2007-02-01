Return-Path: <linux-kernel-owner+w=401wt.eu-S1751553AbXBAVqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbXBAVqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbXBAVqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:46:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbXBAVqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:46:42 -0500
To: Zach Brown <zach.brown@oracle.com>
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>,
       "'Andrew Morton'" <akpm@osdl.org>, <linux-aio@kvack.org>,
       <linux-kernel@vger.kernel.org>, "'Benjamin LaHaise'" <bcrl@kvack.org>,
       <suparna@in.ibm.com>
Subject: Re: [patch] aio: add per task aio wait event condition
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <000001c72f01$7e4e1e30$8b8c030a@amr.corp.intel.com>
	<32AF3D8D-536F-4B9F-908B-C292CB9D6AEE@oracle.com>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Thu, 01 Feb 2007 16:46:08 -0500
In-Reply-To: <32AF3D8D-536F-4B9F-908B-C292CB9D6AEE@oracle.com> (Zach Brown's message of "Wed, 3 Jan 2007 10:50:06 -0800")
Message-ID: <x49hcu5y2jj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

==> On Wed, 3 Jan 2007 10:50:06 -0800, Zach Brown <zach.brown@oracle.com> said:

Zach> The controversial part here happens when min_nr is larger than the
Zach> ring size.  In that case I think we should consider min_nr to be
Zach> equal to the ring size.  We'll return fewer events than userspace
Zach> asked for, but it'll still be a big batch.

That sounds like a programming error, don't you think?  Maybe
returning EINVAL is the right approach?

-Jeff
