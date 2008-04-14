Return-Path: <linux-kernel-owner+w=401wt.eu-S1761008AbYDNOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008AbYDNOqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbYDNOqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:46:10 -0400
Received: from ns.suse.de ([195.135.220.2]:60231 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbYDNOqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:46:09 -0400
Date: Mon, 14 Apr 2008 16:46:34 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Neil Horman <nhorman@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       nickpiggin@yahoo.com.au, k-miyoshi@cb.jp.nec.com, greg@kroah.com,
       kdb@oss.sgi.com, kexec@lists.infradead.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Keith Owens <kaos@ocs.com.au>
Subject: Re: [PATCH 0/2] add new notifier function ,take3
Message-ID: <20080414164634.190e3e0e@strauss.suse.de>
In-Reply-To: <20080414144228.GD1193@hmsendeavour.rdu.redhat.com>
References: <47FF190B.6030406@ah.jp.nec.com>
	<20080411210751.e4a468b2.akpm@linux-foundation.org>
	<20080414134622.GB6941@redhat.com>
	<20080414144228.GD1193@hmsendeavour.rdu.redhat.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Neil Horman [2008-04-14 10:42]:
>
> I know it doesn't particularly relate to this patch, but FWIW, for cases like
> failover, I've inserted infrastrucutre in the userspace part of kdump for
> Fedora/RHEL to support this sort of thing.  We can run arbitrary scripts righte
> before and after a capture so that notifications can be sent to remote nodes in
> a much safer fashion than using the notifier chain after a panic.

But that doesn't help if you want to use a debugger (KDB, KGDB).


	Bernhard
