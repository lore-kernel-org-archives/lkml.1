Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbYGVM6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbYGVM6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYGVM6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:58:40 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35606 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbYGVM6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:58:39 -0400
Date: Tue, 22 Jul 2008 17:02:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [PATCH -mm] coredump: format_corename: don't append .%pid if multi-threaded
Message-ID: <20080722130206.GA3297@tv-sign.ru>
References: <200807210137.m6L1bN0H011138@imap1.linux-foundation.org> <20080721102940.666d733d@the-village.bc.nu> <20080721210121.C5E741541A5@magilla.localdomain> <20080721221416.6d4f9014@lxorguk.ukuu.org.uk> <20080722113731.GA1383@tv-sign.ru> <20080722121824.GB1383@tv-sign.ru> <cfd18e0f0807220521x5faea19bn1f545b23b84ead6a@mail.gmail.com> <20080722124314.GA3267@tv-sign.ru> <cfd18e0f0807220547w691346ecyd4819fa4b7c23325@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0807220547w691346ecyd4819fa4b7c23325@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Michael Kerrisk wrote:
>
> On Tue, Jul 22, 2008 at 2:43 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> >
> > That said, this is the user-visible change...
>
> True.  Not sure how important that is in this case though.  What is
> the reason for making this change (other than tidiness)?

Tidiness is the only reason.

Please don't hesitate to nack this patch if you think we shouldn't
change the historical behaviour, the cleanup is very minor.

As for me, I think it is a bit strange we append "%.pid" depending on
is_multithreaded, the same app can have 1 or more threads for various
reasons when the coredump happens, but this behaviour is very old and
perhaps it is too late to change.

Oleg.

