Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbZDOUWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbZDOUWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZDOUWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:22:40 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48502 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbZDOUWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:22:40 -0400
Date: Wed, 15 Apr 2009 15:22:20 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: CAP_SYS_ADMIN on restart(2) (was: Re: [PATCH 00/30] C/R
	OpenVZ/Virtuozzo style)
Message-ID: <20090415202220.GA5228@us.ibm.com>
References: <20090410023207.GA27788@x200.localdomain> <1239340031.24083.21.camel@nimitz> <20090413091423.GA19236@x200.localdomain> <49E4108A.8050201@cs.columbia.edu> <20090414145830.GA27461@x200.localdomain> <49E4D115.5080601@cs.columbia.edu> <20090414204912.GA28458@x200.localdomain> <20090414213934.GB17986@us.ibm.com> <20090415192150.GC26994@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415192150.GC26994@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> Is sysctl to control CAP_SYS_ADMIN on restart(2) OK?

You mean a sysctl to specify whether to require CAP_SYS_ADMIN for
restart(2)?

Yeah I wouldn't object to that - it certainly seems like something
sane for an admin to use depending on their users.

Though I think the bigger fish to fry first is whether we only support
whole-container checkpoint/restart.  If that is the case, then
CAP_SYS_ADMIN will always be needed for restart since it will always
unshare some namespaces.

thanks,
-serge
