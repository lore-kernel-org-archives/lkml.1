Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbZAHPOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbZAHPOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZAHPOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:14:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZAHPOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:14:33 -0500
Date: Thu, 8 Jan 2009 16:14:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [PATCH] mtrr: fix types used in userspace exported header
Message-ID: <20090108151419.GB24420@elte.hu>
References: <20090108150126.GA9483@bombadil.infradead.org> <20090108150430.GA15684@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108150430.GA15684@bombadil.infradead.org>
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


* Kyle McMartin <kyle@infradead.org> wrote:

> From: Kyle McMartin <kyle@redhat.com>
> 
> Commit 932d27a7913fc6b3c64c6e6082628b0a1561dec9 exported some mtrr
> structures without using the exportable __uX types, causing userspace
> build failures.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> ---
> 
> Missed the u8 typedef below the struct.

applied to tip/x86/urgent, thanks Kyle!

	Ingo
