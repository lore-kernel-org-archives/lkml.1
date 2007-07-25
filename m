Return-Path: <linux-kernel-owner+w=401wt.eu-S1761263AbXGYUpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbXGYUpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbXGYUp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:45:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:51394 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbXGYUp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:45:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rNHjs6DD8kCVpWertcKiC5vpgzEXgUP8egIPjbC7l7NAf+tEWNqSqjRIyjRZNsW9m952ceGhWg09qD0Xe9sG8I1iRgYXlUGd9tlqpe46zB2odkHkjKSXxFlzZWjrHYARkwZWHc8/6/9b3GFRz1I9dFDyu1HqCtRq3O5ynH54HMQ=
Message-ID: <46A7B59F.8070507@googlemail.com>
Date: Wed, 25 Jul 2007 22:42:07 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, p.hardwick@option.com
Subject: Re: 2.6.23-rc1-mm1 - drivers/char/nozomi.c overflow in implicit constant
 conversion , warnings
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


...

drivers/char/nozomi.c: In function 'interrupt_handler':
drivers/char/nozomi.c:1298: warning: overflow in implicit constant conversion
drivers/char/nozomi.c: In function 'nozomi_card_init':
drivers/char/nozomi.c:1568: warning: overflow in implicit constant conversion
drivers/char/nozomi.c:1592: warning: overflow in implicit constant conversion
drivers/char/nozomi.c: In function 'nozomi_card_exit':
drivers/char/nozomi.c:1673: warning: overflow in implicit constant conversion

...


config is a allmodconfig.


Regards,

Gabriel C 
