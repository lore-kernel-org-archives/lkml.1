Return-Path: <linux-kernel-owner+w=401wt.eu-S965438AbXFFWlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965438AbXFFWlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965362AbXFFWj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:39:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46905 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965357AbXFFWj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:39:57 -0400
Date: Wed, 6 Jun 2007 17:39:52 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, menage@google.com,
       akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070606223952.GB5626@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com> <20070604191412.GA901@sergelap.austin.ibm.com> <20070604123151.4db007a6.pj@sgi.com> <6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com> <20070604204131.GB19409@sergelap.austin.ibm.com> <20070604140533.65e25286.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604140533.65e25286.pj@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Jackson (pj@sgi.com):
> > Would it then make sense to just
> > default to (parent_set - sibling_exclusive_set) for a new sibling's
> > value?
> 
> Which could well be empty, which in turn puts one back in the position
> of dealing with a newborn cpuset that is empty (of cpus or of memory),
> or else it introduces a new and odd constraint on when cpusets can be
> created (only when there are non-exclusive cpus and mems available.)
> 
> > An option is fine with me, but without such an option at all, cpusets
> > could not be applied to namespaces...
> 
> I wasn't paying close enough attention to understand why you couldn't
> do it in two steps - make the container, and then populate it with
> resources.

Sorry, please clarify - are you saying that now you do understand, or
that I should explain?

> But if indeed that's not possible, then I guess we need some sort of
> option specifying whether to create kids empty, or inheriting.

Paul (uh, Menage :) should I do a patch for this or have you got it
already?

thanks,
-serge
