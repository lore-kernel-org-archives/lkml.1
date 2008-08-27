Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYH0JKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYH0JKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbYH0JKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:10:17 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49934 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbYH0JKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:10:14 -0400
Subject: Re: pull request: wireless-2.6 2008-08-26
From: Marcel Holtmann <holtmann@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: tomasw@gmail.com, linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080827.014041.230100807.davem@davemloft.net>
References: <20080827013009.GA15781@tuxdriver.com>
	 <1ba2fa240808270038r24d5eeb9l36fd70ef5ae904f5@mail.gmail.com>
	 <20080827.014041.230100807.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 13:10:10 +0200
Message-Id: <1219835410.5359.24.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > Afther massive ath9k merge I didn't see it was a conceptual problem.
> 
> Stop right there.
> 
> You don't see it as a problem because you're not the one who has to
> explain all of this shit to Linus and ends up getting flamed by him
> when inappropriate changes are in my tree outside of the merge window.

I did a quick review of the offending patch queue. And some of them
should go in since they are fixing real bugs (as far as I can tell from
a quick review). Others have to clearly wait for the next merge window.

Thomas, please go through the list of patches and pick the real bug
fixes. The cleanup patches can't go in since they are after the merge
window. And being one of the offenders why Dave got flamed by Linus,
there is no way to get these through. And my big offender was a
regression that broke userspace and came with a lengthy commit message.

Speaking of which, you better have a more convincing commit message if
you wanna get something in after the merge window. It should make clear
why this is a bug or a regression and why it can't wait until the next
merge window.

Please take this into account for any future patches since Linus now set
a really high bar for patches after the merge window.

Regards

Marcel


