Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbZIVVuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbZIVVuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZIVVux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:50:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:56643 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbZIVVuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:50:52 -0400
Message-ID: <4AB94697.3030100@kernel.org>
Date: Wed, 23 Sep 2009 06:50:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic	percpu
 and drop the old one
References: <1253605214-23210-1-git-send-email-tj@kernel.org> <20090922081631.GD1475@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E29CCA8E@orsmsx505.amr.corp.intel.com> <57C9024A16AD2D4C97DC78E552063EA3E29CCADC@orsmsx505.amr.corp.intel.com> <57C9024A16AD2D4C97DC78E552063EA3E29CCB18@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E29CCB18@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 21:49:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Luck, Tony wrote:
> I just noticed the "#for-next" in the Subject line for these
> patches.  Do they depend on some stuff in linux-next that is
> not in Linus' tree (pulled today HEAD=7fa07729e...)?  If so, then
> ignore my results.

Nope, it should work on top of Linus's tree.

> Kernel built from generic_defconfig does boot OK though, so I suspect
> this is a discontig vs. contig problem.

Yeah, it's probably something broken with contig SMP configuration.
I've just found a machine with contig mem and multiple processors.
Will test on it later today.

Thanks.

-- 
tejun
