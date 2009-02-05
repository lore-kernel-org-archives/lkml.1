Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbZBERcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbZBERcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759976AbZBERbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:31:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35164 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759957AbZBERbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:31:33 -0500
Date: Thu, 5 Feb 2009 18:30:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: __supported_pte_mask breaks PROT_NONE pages
Message-ID: <20090205173050.GB24599@elte.hu>
References: <498A5002.9080408@goop.org> <20090205142912.GE28443@elte.hu> <498B20A7.4060405@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B20A7.4060405@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> btw., did you actually see a boot crash due to this, on a pre-PGE system?
>>   
>
> No, under Xen, since it also disables PGE.

but it was a boot crash, right? Such info is useful in the first line of a 
commit message:

  Impact: fix non-PGE boot crash

(that also makes it less likely that the commit is under-prioritized.)

	Ingo
