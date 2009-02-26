Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZBZNRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZBZNRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZBZNRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:17:23 -0500
Received: from silene.metacarta.com ([208.80.142.18]:47106 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbZBZNRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:17:23 -0500
Date: Thu, 26 Feb 2009 08:17:20 -0500 (EST)
From: Joe Malicki <jmalicki@metacarta.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bakerkj@metacarta.com, mitz@metacarta.com
Message-ID: <13156243.9761011235654240048.JavaMail.root@ouachita>
In-Reply-To: <20090225162836.63fce3c4.akpm@linux-foundation.org>
Subject: Re: BUG: setuid sometimes doesn't.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.80.142.151]
X-Mailer: Zimbra 5.0.9_GA_2533.UBUNTU6 (ZimbraWebClient - [unknown] (Linux)/5.0.9_GA_2533.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Andrew Morton" <akpm@linux-foundation.org> wrote:

> On Wed, 25 Feb 2009 18:11:54 -0500 (EST)
> Joe Malicki <jmalicki@metacarta.com> wrote:
> >
> 
> wow, good bug report!

Thanks!

> > 
> > Very rarely, we experience a setuid program not properly getting
> > the euid of its owner.
> 
> Do you know which euid it _does_ get?  Is it unchanged, or is it
> random
> garbage, or...?

Sorry, It's unchanged.  (Also, as in other reply, this only seems to
happen for setuid to root on multicore, I jumbled words in the original
report)
