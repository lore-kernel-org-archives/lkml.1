Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbYGZPuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbYGZPuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYGZPuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:50:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37725 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYGZPuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:50:12 -0400
Date: Sat, 26 Jul 2008 17:49:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Xen: Use native_pte_flags instead of
	native_pte_val for .pte_flags
Message-ID: <20080726154956.GC15945@elte.hu>
References: <1216912546-6971-1-git-send-email-ehabkost@redhat.com> <4888A34D.8040607@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4888A34D.8040607@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0025]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Eduardo Habkost wrote:
>> Using native_pte_val triggers the BUG_ON() in the paravirt_ops
>> version of pte_flags().
>>
>> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>>   
>
> Good point.
>
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/xen - thanks.

	Ingo
