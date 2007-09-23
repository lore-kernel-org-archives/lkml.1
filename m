Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbXIWIjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbXIWIjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 04:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbXIWIjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 04:39:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:30619 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXIWIjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 04:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZwUnuk9Oetkds1t+UE6Lu3IqECvi57seYbbrHO6WRqM+b4vFAmgJ9nxJfO61dVvibmUvf7V+zCBlIsKmGEGQtK73b7ohxlB5XPpS85Q9cXpZbfnT4DdbKu67uWO3TLMkH9YDVcnaOSO5hJlj56Ce5CeWN2F4pSSji0oGxP1RzGQ=
Message-ID: <19f34abd0709230139s56b9a9b1yc2cae89488ea5112@mail.gmail.com>
Date: Sun, 23 Sep 2007 10:39:15 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [RFC] New kernel-message logging API
Cc: LKML <linux-kernel@vger.kernel.org>, holzheu <holzheu@linux.vnet.ibm.com>,
       "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>
In-Reply-To: <1190506383.30132.11.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190506383.30132.11.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/07, Joe Perches <joe@perches.com> wrote:
> On Sat, 2007-09-22 at 21:27 +0200, Vegard Nossum wrote:
> > #define kprint(fmt, ...)
>
> Good ideas.  Perhaps a prefix of klog or kp_ instead?
> Given the number of 80 column zealots, character naming length matters.

I don't know. Compare the following two lines:

printk(KERN_INFO "Message.\n");
kprint_info("Message.");

By dropping the lengthy macro (it's not like it's going to change
while we're running anyway, so why not make it a part of the function
name?) and the final newline, we actually end up with a net decrease
in line length.

I thought it would be nice to have something that looks familiar,
since that would ease an eventual transition. klog is a valid
alternative, but isn't kp a bit cryptic?


Vegard
