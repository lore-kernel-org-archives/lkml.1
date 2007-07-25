Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbXGYUkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbXGYUkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbXGYUkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:40:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42130 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760901AbXGYUkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:40:31 -0400
Message-ID: <46A7B46C.9020007@zytor.com>
Date: Wed, 25 Jul 2007 13:37:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, kaos@ocs.com.au,
       xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org> <20070725171956.GF27237@ftp.linux.org.uk> <46A78B47.1070500@goop.org> <46A7B2BF.4000506@redhat.com>
In-Reply-To: <46A7B2BF.4000506@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 07/25/2007 01:41 PM, Jeremy Fitzhardinge wrote:
>> I reported it as a gcc bug, but they refused to hear of it.  Details at
>> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29305
>>
> 
> Wow.
> 
> I especially like "You should plan a better way. "

FWIW, at Transmeta we had a local extension to gcc called
"__builtin_not_reached()" which we used to tell gcc that an assembly
statement would terminate the control flow.

Another useful extension was a variant of __builtin_trap() which would
create a dummy ELF relocation for the trapping instruction with a target.

	-hpa
