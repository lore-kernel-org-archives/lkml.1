Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZKWG4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZKWG4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 01:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZKWG4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 01:56:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59832 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZKWG4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 01:56:01 -0500
Date: Mon, 23 Nov 2009 07:55:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: use default compiler mode by default
Message-ID: <20091123065548.GE31758@elte.hu>
References: <20091122121335.GA24254@redhat.com>
 <20091122091338.4a9d772f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122091338.4a9d772f@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 22 Nov 2009 14:13:35 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > gcc with no flags typically is a sane default for systems to use, and
> > looking at the running kernel is probably broken for cross-builds
> > anyway, so let's not do this.  Add EXTRA_CFLAGS so that users can
> > override default gcc mode if they want to.
> 
> yes please; current perf breaks if you compile it in a 32 bit chroot 
> on a 64 bit system....

ok - applied the patch with your ack.

I'd still like to hear back from Paulus whether PowerPC is affected 
negatively - IIRC it was PowerPC where we got the -m64 from originally.

Thanks,

	Ingo
