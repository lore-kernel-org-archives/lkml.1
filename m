Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYL0JsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYL0JsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYL0JsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:48:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58194 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbYL0JsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:48:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081226102716.GA31450@uranus.ravnborg.org>
References: <20081226102716.GA31450@uranus.ravnborg.org> <20081219105441.GA19750@linux.vnet.ibm.com> <86802c440812190351q3118516aif664dd5869c21b2a@mail.gmail.com> <20081219134636.GA11772@linux.vnet.ibm.com> <494C0BF0.3080109@kernel.org> <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> 
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, Yinghai Lu <yinghai@kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333 smp_call_function_mask
Date: Sat, 27 Dec 2008 09:46:58 +0000
Message-ID: <3677.1230371218@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> I recall David Howells had a similar issue with the bootparamter patch set.
> The workaround he used was to add a barrier(); call in the weak function
> to avoid the inline.

Yes I did.  Rusty's solution was just to move the default weak functions into
different files.

Attempting to use the noinline attribute does not work.

Of course, you could just stick the functions into lib/ in separate .c files
and dispense with the weak attribute altogether.

David
