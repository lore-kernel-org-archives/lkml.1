Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0CIQEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:04:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:60539 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0CIQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:04:41 -0500
Subject: Re: [PATCH] i2c: update for semaphore to mutex conversion of
 devices
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>, tglx <tglx@linutronix.de>
In-Reply-To: <20100308235953.GA7808@kroah.com>
References: <20100309102828.18351564.sfr@canb.auug.org.au>
	 <20100308235953.GA7808@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 17:04:37 +0100
Message-ID: <1268150677.5037.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 15:59 -0800, Greg KH wrote:
> 
> Hopefully the lockdep core will be tweaked to handle the locking tree
> that the device core requires and then when that happens, I will merge
> the patch that will require this fix in order to keep the build from
> breaking.
> 
?! Thomas send you patch shutting lockdep up for device mutex, look for
<alpine.LFD.2.00.1002181116410.2811@localhost.localdomain> in your
inbox.

