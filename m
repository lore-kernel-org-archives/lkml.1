Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbXHHJR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbXHHJR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbXHHJRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:17:21 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:33147 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbXHHJRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=h3IhETAbIGFADoinSV24gEv0K9SuI6nQVKJXNHfU4uEHPiGv1TDgoq6mZLI/1gv7gpwP3tHyp+ZhPELtOHnGH7m0xiwwd9brfMyXPnLYNqLdhOaTnBMvN6wn4FpQhc9beXvINXJRtk73fmn7ffm2JnQZ2Y7n0QBazr2sgJRdgYI=
Date: Wed, 8 Aug 2007 17:17:53 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] take sched_debug.c out of nasal demon territory
Message-ID: <20070808091752.GA5548@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070806032659.GX21089@ftp.linux.org.uk> <Pine.LNX.4.64.0708061750270.13469@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708061750270.13469@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 05:51:29PM +0200, Jan Engelhardt wrote:
>
>On Aug 6 2007 04:26, Al Viro wrote:
>>
>>	C99 6.10.3[11]: preprocessing directive within the argument list
>>of macro invocation => undefined behaviour.  Don't do that...
>
>String concatenation ("a" "b") is not a preprocessing directive.
>
>$ gcc -E test.c
># 1 "test.c"
># 1 "<built-in>"
># 1 "<command line>"
># 1 "test.c"
>printf("a" "b");
>
>(If it was, the "a" "b" would have already been joined.)
>

Yes. According to C99 5.1.1.2, string concatenation is done in Phase 6,
that's after preprocessing.

Regards.

-- 
_   /|
\'o.O'
=(___)=
   U    ack!
