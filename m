Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXLEPcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXLEPcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXLEPcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:32:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbXLEPck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:32:40 -0500
Date: Wed, 5 Dec 2007 16:32:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@googlemail.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org,
       markus.t.metzger@intel.com, mtk.manpages@gmail.com, roland@redhat.com,
       suresh.b.siddha@intel.com
Subject: Re: [patch 1/2] x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071205153219.GA5490@elte.hu>
References: <a430082a0712041004q4d779332x63b0208ab8f1b5ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a430082a0712041004q4d779332x63b0208ab8f1b5ae@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Markus Metzger <markus.t.metzger@googlemail.com> wrote:

> Changes to the last version:
> - split implementation into two layers: ds/bts and ptrace
> - renamed TIF's
> - save/restore ds save area msr in __switch_to_xtra()
> - make block-stepping only look at BTF bit

hm, i tried to merge your patches, but they were word-wrapped, for 
example here:

> +   After the first warp-around, this is the start of the circular bts
> buffer. */

(there's Documentation/email-clients.txt with more info about how to 
avoid this.)

	Ingo
