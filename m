Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYCZGem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYCZGem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYCZGeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:34:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53282 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbYCZGeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:34:17 -0400
Date: Wed, 26 Mar 2008 07:34:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] NR_CPUS: third reduction of NR_CPUS memory usage
	x86-version v2
Message-ID: <20080326063401.GE18301@elte.hu>
References: <20080325220650.835342000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325220650.835342000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Wii, isn't this fun...!  This is a resubmission of yesterday's patches 
> based on the x86.git/latest tree.  Yes, it _is_ a maze of twisty litle 
> passages. ;-)

just to make patch dependencies clear: most of the patches here can be 
applied to their base trees as-is, without depending on any other patch, 
correct?

the only undeclared dependency i found was the cpumask_scnprintf_len() 
patch - please prominently list dependencies in the changelog like this:

 [ this patch depends on "cpumask: Add cpumask_scnprintf_len function" ]

	Ingo
