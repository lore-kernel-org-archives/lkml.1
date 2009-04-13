Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZDMTGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZDMTGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZDMTGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:06:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49431 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZDMTGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:06:22 -0400
Date: Mon, 13 Apr 2009 15:03:19 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       Valdis.Kletnieks@vt.edu, travis@sgi.com, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, rusty@rustcorp.com.au, lenb@kernel.org
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Message-ID: <20090413190319.GA4261@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
	Valdis.Kletnieks@vt.edu, travis@sgi.com,
	linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
	rusty@rustcorp.com.au, lenb@kernel.org
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu> <20090413102749.4ca3a217.akpm@linux-foundation.org> <alpine.LFD.2.00.0904131040350.4583@localhost.localdomain> <20090413114932.44b47910.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413114932.44b47910.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 11:49:32AM -0700, Andrew Morton wrote:
 > On Mon, 13 Apr 2009 10:45:45 -0700 (PDT)
 > > 
 > > IOW, why not just do
 > > 
 > > 	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
 > > 
 > > here?
 > > 
 > 
 > Didn't know it existed :(

heh. I'm going to run with that excuse too.
Remember the days when you could fit the kernels API in your head? :)

	Dave

