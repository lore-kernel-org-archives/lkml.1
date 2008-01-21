Return-Path: <linux-kernel-owner+w=401wt.eu-S1761222AbYAUQMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222AbYAUQMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 11:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYAUQMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 11:12:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbYAUQMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 11:12:23 -0500
Date: Mon, 21 Jan 2008 17:12:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: bad page table when accessing /dev/mem in dmidecode
Message-ID: <20080121161203.GA29062@elte.hu>
References: <20080121024422.GA23494@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121024422.GA23494@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> When booting git-x86 tip 28a0fcd6b38e247200bd857996375aee91eae8ce on a 
> core2 system the userland running dmidecode at boot hits:

should be fixed in latest x86.git. (i've reverted the core PAT changes - 
they'll probably have to wait until v2.6.26)

	Ingo
