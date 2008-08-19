Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYHSBgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYHSBgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYHSBfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:35:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbYHSBfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:35:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Ratan Nalumasu" <rnalumasu@gmail.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Ulrich Drepper" <drepper@redhat.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Patch for improving wait performance with NPTL
In-Reply-To: Ratan Nalumasu's message of  Monday, 18 August 2008 18:04:00 -0700 <93ad5f3f0808181804m3b74fe68v1fdcf4edf6c7b465@mail.gmail.com>
References: <93ad5f3f0808181334i684e68b7yb61e3586d35880f6@mail.gmail.com>
	<20080819005439.GA14821@elte.hu>
	<93ad5f3f0808181804m3b74fe68v1fdcf4edf6c7b465@mail.gmail.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080819013517.C8F741542BC@magilla.localdomain>
Date: Mon, 18 Aug 2008 18:35:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All that code should be private to exit.c and just use
init_waitqueue_func_entry.


Thanks,
Roland
