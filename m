Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbYCLWJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbYCLWJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYCLWJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:09:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40696 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYCLWJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:09:05 -0400
Date: Thu, 13 Mar 2008 01:08:24 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/6] signals: send_signal: factor out SIGNAL_GROUP_EXIT checks
Message-ID: <20080312220824.GA120@tv-sign.ru>
References: <20080309185926.GA5649@tv-sign.ru> <20080311021633.BF1B326F991@magilla.localdomain> <20080311175122.GA586@tv-sign.ru> <20080311203206.2DAC526F991@magilla.localdomain> <20080312054909.GA163@tv-sign.ru> <20080312215406.A786526F992@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312215406.A786526F992@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12, Roland McGrath wrote:
>
> > Of course, since I personally don't agree, I'd like to discuss it more
> > if possible.
> 
> The point is that, whenever possible, a semantics change should be
> isolated into a patch separate from any related cleanups.  More
> important than that, no semantics change should go unmentioned so
> it's only documented as a result of someone's careful review of
> the change.

Yes. You are very right.

And. I must admit. I didn't even realize that the added semantics change
worth at least a special note in changelog because it is easily visible.
This was really wrong in any case. Thanks for pointing out this.

Oleg.

