Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbXFDUlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbXFDUlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbXFDUle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:41:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50186 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbXFDUld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:41:33 -0400
Date: Mon, 4 Jun 2007 15:41:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070604204131.GB19409@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com> <20070604191412.GA901@sergelap.austin.ibm.com> <20070604123151.4db007a6.pj@sgi.com> <6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On 6/4/07, Paul Jackson <pj@sgi.com> wrote:
> >
> >Yup - early in the life of cpusets, a created cpuset inherited the cpus
> >and mems of its parent.  But that broke the exclusive property big
> >time.  You will recall that a cpu_exclusive or mem_exclusive cpuset
> >cannot overlap the cpus or memory, respectively, of any of its sibling
> >cpusets.
> >
> 
> Maybe we could make it a per-cpuset option whether children should
> inherit mems/cpus or not?

The values can be changed after the cpuset is populated, right?  So
really these are just defaults?  Would it then make sense to just
default to (parent_set - sibling_exclusive_set) for a new sibling's
value?

An option is fine with me, but without such an option at all, cpusets
could not be applied to namespaces...

thanks,
-serge
