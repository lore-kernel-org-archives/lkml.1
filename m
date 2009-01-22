Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbZAVWmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbZAVWmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZAVWmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:42:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbZAVWmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:42:23 -0500
Date: Thu, 22 Jan 2009 23:42:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] xen: actually release memory when shrinking domain
Message-ID: <20090122224205.GA17450@elte.hu>
References: <4978F4D8.6090706@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4978F4D8.6090706@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1540]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Dan Magenheimer <dan.magenheimer@oracle.com>
>
> Fix this:
>
>> It appears that in the upstream balloon driver,
>> > the call to HYPERVISOR_update_va_mapping is missing
>> > from decrease_reservation.  I think as a result,
>> > the balloon driver is eating memory but not
>> > releasing it to Xen, thus rendering the balloon
>> > driver essentially useless.  (Can be observed via xentop.)
>
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> drivers/xen/balloon.c |    5 +++++
> 1 file changed, 5 insertions(+)

applied to tip/x86/urgent, thanks!

	Ingo
