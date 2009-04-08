Return-Path: <linux-kernel-owner+w=401wt.eu-S1762620AbZDHT6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620AbZDHT6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbZDHT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:57:58 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:49550 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbZDHT55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:57:57 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ptrace: checkpatch fixes
Date: Wed, 8 Apr 2009 21:57:54 +0200
User-Agent: KMail/1.9.9
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com> <alpine.LFD.2.00.0904081007530.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904081007530.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904082157.54134.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 08 April 2009 19:19:36 schrieb Linus Torvalds:
>   And some lines just end up long.  I think 100 characters may be a
>   more reasonable limit for "too long", but quite frankly, it depends on
>   the line.
> 
>   So I think 'checkpatch' is pure crap in this area, and I've told
>   people so before, and they keep telling me that it has relaxed it's
>   idiotic warnings, but that is apparently just a lie. ]
> 
> Oh well.  If I actually read perl, I could parse what the hell those
> 80-character rules are in checkpath.  It already has random "it's ok if
> X" stuff.  But it never seems to really have any "oh, but splitting is
> worse" logic. 

Isnt checkpatch just following what is written down in the Documentation folder? Maybe adopting the following part of CodingStyle and add more examples for good and bad would give the checkpatch authors a better idea about your intent.

--------- snip---------
                Chapter 2: Breaking long lines and strings

Coding style is all about readability and maintainability using commonly
available tools.

The limit on the length of lines is 80 columns and this is a strongly
preferred limit.

Statements longer than 80 columns will be broken into sensible chunks.
Descendants are always substantially shorter than the parent and are placed
substantially to the right. The same applies to function headers with a long
argument list. Long strings are as well broken into shorter strings. The
only exception to this is where exceeding 80 columns significantly increases
readability and does not hide information.

void fun(int a, int b, int c)
{
        if (condition)
                printk(KERN_WARNING "Warning this is a long printk with "
                                                "3 parameters a: %u b: %u "
                                                "c: %u \n", a, b, c);
        else
                next_statement;
}
----------snip---------

