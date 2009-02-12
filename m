Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbZBLWIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbZBLWIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZBLWI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:08:29 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34965 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZBLWI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:08:28 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: fweisbec@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       oleg@redhat.com, travis@sgi.com, a.p.zijlstra@chello.nl,
       mm-commits@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: + work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to -mm tree
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
	<20090203121147.GB19979@elte.hu>
	<c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
	<20090203112529.26e6bf76.akpm@linux-foundation.org>
	<m18wobcrw3.fsf@fess.ebiederm.org>
	<20090212124835.2fc41620.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 12 Feb 2009 14:08:09 -0800
In-Reply-To: <20090212124835.2fc41620.akpm@linux-foundation.org> (Andrew Morton's message of "Thu\, 12 Feb 2009 12\:48\:35 -0800")
Message-ID: <m1eiy3z4ty.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org, a.p.zijlstra@chello.nl, travis@sgi.com, oleg@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> The problem with set_cpus_allowed() is that some other
> suitably-privileged userspace process can come in from the side and
> modify your cpus_allowed at any time.

According to the comments the only reason we care is so that
we get the appropriate NUMA affinity by default.  I don't
think it would be fatal if userspace messed around and we
had a wrong value.

Does work_on_cpu prevent that?

Eric

