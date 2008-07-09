Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYGIU0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYGIU0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYGIU0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:26:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47824 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYGIU0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:26:31 -0400
Date: Wed, 9 Jul 2008 22:26:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies
Message-ID: <20080709202607.GH14009@elte.hu>
References: <patchbomb.1215554782@localhost> <200807092202.27013.rjw@sisk.pl> <20080709200428.GB14009@elte.hu> <200807092217.53222.rjw@sisk.pl> <48751E34.3060100@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48751E34.3060100@goop.org>
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

>> I'll have a look at the remaining related patches and see what can be 
>> done.
>>
>> Jeremy, what exactly do you need the !PM && PM_SLEEP combination for, 
>> BTW?
>
> See drivers/xen/manage.c.  On the Xen save/restore path, I call 
> device_(suspend|resume|power_down|power_up)(), primarily to get the 
> system timers into a good state after the machine has been away for a 
> while.  Xen doesn't have a general dependency on the rest of the PM 
> infrastructure.

see the last config link i sent - even with my fixes i couldnt get it to 
work. So there were quite a few dependencies i think.

	Ingo
