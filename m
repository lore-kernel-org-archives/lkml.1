Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbZJPQbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbZJPQbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 12:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZJPQbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 12:31:45 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:53118 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751822AbZJPQbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 12:31:45 -0400
Date: Fri, 16 Oct 2009 12:23:51 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: "Luck, Tony" <tony.luck@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@redhat.com" <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "cebbert@redhat.com" <cebbert@redhat.com>
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
In-Reply-To: <4AD6E29B.8000506@kernel.org>
Message-ID: <alpine.DEB.1.10.0910161223010.11490@gentwo.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com> <alpine.DEB.1.10.0910141420300.9708@gentwo.org>
 <57C9024A16AD2D4C97DC78E552063EA3E3226704@orsmsx505.amr.corp.intel.com> <alpine.DEB.1.10.0910141445110.30078@gentwo.org> <4AD6E29B.8000506@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Tejun Heo wrote:

> __ia64_per_cpu_var() is slightly different from this_cpu_read() in
> that the former only works for percpu variables which fall on the
> first percpu page - ie. static percpu vars in the kernel image.  So,
> __ia64_per_cpu_var() is a bit more efficient than this_cpu_read() as
> it doesn't have to compute the address.
>
> So, what we can do is to leave the macro alone for now and then add
> sparse annotation to it later in the patch as it's basically another
> specialized accessor.  How does that sound?

Ok. The macro would be arch specific anyways.

