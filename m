Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbYEACw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbYEACw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYEACwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:52:18 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:12650 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802AbYEACwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:52:17 -0400
From: Frans Pop <elendil@planet.nl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 04:52:13 +0200
User-Agent: KMail/1.9.9
Cc: paulus@samba.org, torvalds@linux-foundation.org, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jirislaby@gmail.com
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org> <18457.219.995207.136771@cargo.ozlabs.ibm.com> <18457.219.995207.136771@cargo.ozlabs.ibm.com> <48192376.7060108@garzik.org>
In-reply-To: <48192376.7060108@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010452.14475.elendil@planet.nl>
X-OriginalArrivalTime: 01 May 2008 02:52:14.0976 (UTC) FILETIME=[5C92B000:01C8AB36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Paul Mackerras wrote:
>> By the way, if you do want to make that rule, then there's a really
>> easy way to do it - just pull linux-next, and make that one pull be
>> the entire merge window. :)
> 
> That's a unique and interesting idea...

Full ack.

Especially if there was some kind of "pre-merge linux-next freeze" where 
people (arch maintainers, kernel testers) would be actively invited to do 
pre-merge testing.

During that period only changes that fix reported issues (be it build issues 
or regressions) would be allowed:
- either a revert of the problematic commit
- or a targeted fix

This could even hugely improve the bisectability of mainline after the merge 
as such changes could be merged/rebased into the subsystem tree _before_ 
Linus pulls them into mainline.

Currently I avoid -next and -mm and I also don't do any merge window 
testing. Why? Too much flux, too many issues, too much energy required.
But if there was some sort of pre-merge call for testing of an identifiable 
and relatively stable tree, I would definitely participate in that and be 
willing to spend time to bisect the hell out of any issues I'd find.

Cheers,
FJP
