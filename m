Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYGIUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYGIUnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYGIUnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:43:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34674 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYGIUnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:43:05 -0400
Date: Wed, 9 Jul 2008 22:42:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies
Message-ID: <20080709204238.GA4298@elte.hu>
References: <patchbomb.1215554782@localhost> <200807092217.53222.rjw@sisk.pl> <48751E34.3060100@goop.org> <200807092233.08930.rjw@sisk.pl> <487521F7.6070708@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487521F7.6070708@goop.org>
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

> Rafael J. Wysocki wrote:
>> It does.  And it depends on PM, because HIBERNATION and SUSPEND both depend
>> on PM.
>>   
>
> OK, so can we change PM_SLEEP to depend on PM && (HIBERNATE || SUSPEND
> || XEN)?
>
> Or I could add a separate XEN_SAVE_RESTORE config which depends on PM, 
> and then we make PM_SLEEP depend on XEN_SAVE_RESTORE.

another way would be to select PM_SLEEP if PM is enabled, from within 
XEN. (this is one of the rare cases where select is valid - as PM_SLEEP 
is not an interactive option)

	Ingo
