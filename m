Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbXFDVFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbXFDVFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXFDVFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:05:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42116 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753549AbXFDVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:05:34 -0400
Date: Mon, 4 Jun 2007 14:05:33 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: menage@google.com, serue@us.ibm.com, akpm@linux-foundation.org, dev@sw.ru,
       xemul@sw.ru, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-Id: <20070604140533.65e25286.pj@sgi.com>
In-Reply-To: <20070604204131.GB19409@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070604191412.GA901@sergelap.austin.ibm.com>
	<20070604123151.4db007a6.pj@sgi.com>
	<6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
	<20070604204131.GB19409@sergelap.austin.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Would it then make sense to just
> default to (parent_set - sibling_exclusive_set) for a new sibling's
> value?

Which could well be empty, which in turn puts one back in the position
of dealing with a newborn cpuset that is empty (of cpus or of memory),
or else it introduces a new and odd constraint on when cpusets can be
created (only when there are non-exclusive cpus and mems available.)

> An option is fine with me, but without such an option at all, cpusets
> could not be applied to namespaces...

I wasn't paying close enough attention to understand why you couldn't
do it in two steps - make the container, and then populate it with
resources.

But if indeed that's not possible, then I guess we need some sort of
option specifying whether to create kids empty, or inheriting.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
