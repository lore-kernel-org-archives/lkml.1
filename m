Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbYI3HH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbYI3HH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYI3HHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:07:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33024 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYI3HHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:07:49 -0400
Date: Tue, 30 Sep 2008 09:07:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org, kkeil@suse.de,
       agospoda@redhat.com, arjan@linux.intel.com, david.graham@intel.com,
       bruce.w.allan@intel.com, jkosina@suse.cz, john.ronciak@intel.com,
       tglx@linutronix.de, chris.jones@canonical.com, tim.gardner@intel.com,
       airlied@gmail.com
Subject: Re: [RFC PATCH 01/12] x86: export set_memory_ro and set_memory_rw
Message-ID: <20080930070731.GA30927@elte.hu>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <20080930031922.22950.84239.stgit@jbrandeb-bw.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930031922.22950.84239.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Brandeburg <jesse.brandeburg@intel.com> wrote:

> From: Bruce Allan <bruce.w.allan@intel.com>
> 
> Export set_memory_ro() and set_memory_rw() calls for use by drivers 
> that need to have more debug information about who might be writing to 
> memory space. this was initially developed for use while debugging a 
> memory corruption problem with e1000e.

applied to tip/x86/exports, thanks Jesse.

	Ingo
