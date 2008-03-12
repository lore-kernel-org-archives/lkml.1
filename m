Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYCLFtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYCLFtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYCLFto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:49:44 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56984 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbYCLFtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:49:42 -0400
Date: Wed, 12 Mar 2008 08:49:09 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/6] signals: send_signal: factor out SIGNAL_GROUP_EXIT checks
Message-ID: <20080312054909.GA163@tv-sign.ru>
References: <20080309185926.GA5649@tv-sign.ru> <20080311021633.BF1B326F991@magilla.localdomain> <20080311175122.GA586@tv-sign.ru> <20080311203206.2DAC526F991@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311203206.2DAC526F991@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please drop these patches:

	signals-send_signal-factor-out-signal_group_exit-checks.patch
	signals-fold-sig_ignored-into-prepare_signal.patch
	signals-document-cld_continued-notification-mechanics.patch

(the last one refers to prepare_signal() introduced in the first one,
 and the comment doesn't match the canonical style)

On 03/11, Roland McGrath wrote:
>
> There are arguments to be had about deciding that change to the behavior.
> We can discuss it more if you like.

Of course, since I personally don't agree, I'd like to discuss it more
if possible.

> But that is rather different from
> quietly rolling in your choices of behavior change to a "cleanup" patch.

"[PATCH 3/6] signals: use __group_complete_signal() for the specific signals too"
adds a behaviour change too.

Surely, I don't want to change the behaviour quietly, that is why I am
cc'ing maintainers.

(note also these patches are 8/6, 9/6. Originally I was going to send
 them in a separate series).

Oleg.

