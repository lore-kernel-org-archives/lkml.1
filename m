Return-Path: <linux-kernel-owner+w=401wt.eu-S964813AbXBAWZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813AbXBAWZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964852AbXBAWZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:25:31 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:48681 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813AbXBAWZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:25:30 -0500
In-Reply-To: <x49hcu5y2jj.fsf@segfault.boston.devel.redhat.com>
References: <000001c72f01$7e4e1e30$8b8c030a@amr.corp.intel.com> <32AF3D8D-536F-4B9F-908B-C292CB9D6AEE@oracle.com> <x49hcu5y2jj.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <D277CD72-D8D7-4F93-A82D-209E00DC8055@oracle.com>
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>,
       "'Andrew Morton'" <akpm@osdl.org>, <linux-aio@kvack.org>,
       <linux-kernel@vger.kernel.org>, "'Benjamin LaHaise'" <bcrl@kvack.org>,
       <suparna@in.ibm.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch] aio: add per task aio wait event condition
Date: Thu, 1 Feb 2007 14:21:41 -0800
To: Jeff Moyer <jmoyer@redhat.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That sounds like a programming error, don't you think?  Maybe
> returning EINVAL is the right approach?

Maybe.  I think I'd prefer to be permissive and queue as much as  
possible, but it's not a strong preference.  Returning EINVAL seems  
ok, too.

- z
