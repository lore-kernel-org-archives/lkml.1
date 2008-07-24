Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYGXK3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYGXK3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYGXK30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:29:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbYGXK3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:29:25 -0400
Date: Thu, 24 Jul 2008 12:29:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xen: don't use sysret for sysexit32
Message-ID: <20080724102911.GC28817@elte.hu>
References: <488520A6.8000303@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488520A6.8000303@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0578]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When implementing sysexit32, don't let Xen use sysret to return to 
> userspace.  That results in usermode register state being trashed.

applied to tip/x86/urgent, thanks Jeremy.

	Ingo
