Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZKWSDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZKWSDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZKWSDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:03:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47498 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbZKWSDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:03:21 -0500
Date: Mon, 23 Nov 2009 19:03:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robin Holt <holt@sgi.com>
Cc: tglx@linutronix.de, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/8] x86: UV - XPC fixes with related support
 functionality V2.
Message-ID: <20091123180321.GB15594@elte.hu>
References: <20091119173157.337874000@alcatraz.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119173157.337874000@alcatraz.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> 
> The UV BIOS has been updated to implement some of our interface
> functionality differently than originally expected.  These patches
> update us to that working bios and include a few minor bug fixes
> which prevent us from doing significant testing on real hardware.
> 
> Changes from V1:
> 
> - Actually include the patch introducing the gru_read_gpa.  This
>   was missed in the V1 submission.
> 
> - One additional BIOS change has the OS no longer passing blade
>   to the BIOS when registering a message queue watchlist.

Note, the patches are a bit hard to review without diffstats - mind 
generating them for future patches? Also, putting a 'summary' diffstat 
(the total diffstat effect of all patches) into the 0/8 description mail 
is common courtesy that is much welcome by maintainers and reviewers as 
well.

Thanks,

	Ingo
