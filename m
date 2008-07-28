Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYG1M2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYG1M2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYG1M2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:28:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37041 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYG1M2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:28:25 -0400
Date: Mon, 28 Jul 2008 14:28:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] x86: fix initialization of 'l' bit in ldt descriptors
Message-ID: <20080728122806.GD5515@elte.hu>
References: <488C9768.8090000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488C9768.8090000@goop.org>
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

> Make sure that fill_ldt() initializes the 'l' bit in the descriptor. 
> It always sets it to 0, ignoring 'lm' in user_desc, preserving 
> original x86_64 behaviour.
>
> Previously it was leaving 'l' uninitialized.

applied to tip/x86/xen. (will propagate it to x86/urgent after a bit of 
testing) Thanks,

	Ingo
