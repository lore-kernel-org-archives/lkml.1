Return-Path: <linux-kernel-owner+w=401wt.eu-S1767697AbXCJBAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767697AbXCJBAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767698AbXCJBAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:00:45 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:34846 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767697AbXCJBAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:00:44 -0500
Date: Sat, 10 Mar 2007 02:00:41 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Paul Jackson <pj@sgi.com>
Cc: vatsa@in.ibm.com, menage@google.com, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, akpm@linux-foundation.org,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru
Subject: Re: [PATCH 1/2] rcfs core patch
Message-ID: <20070310010041.GD3647@MAIL.13thfloor.at>
Mail-Followup-To: Paul Jackson <pj@sgi.com>, vatsa@in.ibm.com,
	menage@google.com, ebiederm@xmission.com, winget@google.com,
	containers@lists.osdl.org, akpm@linux-foundation.org,
	ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	xemul@sw.ru
References: <20070301133543.GK15509@in.ibm.com> <20070301134528.GL15509@in.ibm.com> <m1slcg8m4f.fsf@ebiederm.dsl.xmission.com> <20070308101347.GA29051@in.ibm.com> <20070309004816.GB4506@MAIL.13thfloor.at> <20070309181422.GB21661@in.ibm.com> <20070309112547.3e82deca.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309112547.3e82deca.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 11:25:47AM -0800, Paul Jackson wrote:
> > Ease of use maybe. Scripts can be more readily used with a fs-based
> > interface.
> 
> And, as I might have already stated, file system API's are a natural
> fit for hierarchically shaped data, especially if the nodes in the
> hierarchy would benefit from file system like permission attributes.

personally, I'd prefer to avoid hierarchical
structures wherever possible, because they tend
to make processing and checks a lot more complicated
than necessary, and if we really want hierarchical
structures, it might be more than sufficient to
keep the hierarchy in userspace, and use a flat
representation inside the kernel ...

but hey, I'm all for running a hypervisor under
a hypervisor running inside a hypervisor :)

best,
Herbert

> -- 
>                   I won't rest till it's the best ...
>                   Programmer, Linux Scalability
>                   Paul Jackson <pj@sgi.com> 1.925.600.0401
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
