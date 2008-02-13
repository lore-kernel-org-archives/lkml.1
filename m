Return-Path: <linux-kernel-owner+w=401wt.eu-S1763459AbYBMXjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763459AbYBMXjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbYBMXik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:38:40 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:64755 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbYBMXih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:38:37 -0500
From: Junio C Hamano <junio@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
References: <20080213070215.GA11969@kroah.com>
 <20080212.230423.172781444.davem@davemloft.net>
 <1202887323.3129.10.camel@localhost> <20080213165924.GB10129@suse.de>
 <1202923995.3129.26.camel@localhost>
 <alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org>
 <alpine.LFD.1.00.0802131014240.2920@woody.linux-foundation.org>
cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@suse.de>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2008 15:38:20 -0800
In-Reply-To: <alpine.LFD.1.00.0802131014240.2920@woody.linux-foundation.org>
 (Linus Torvalds's message of "Wed, 13 Feb 2008 10:19:25 -0800 (PST)")
Message-ID: <7v4pcco2ab.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 13 Feb 2008, Linus Torvalds wrote:
>> 
>> So in that sense, I think both MAINTAINERS and the deprecation schedule 
>> are totally uninteresting. Yes, they have merge conflicts. But those merge 
>> conflicts are really really easy to handle.
>
> That, btw, includes "automatic merges" for something like a Linux-next 
> tree. It's easy to just make something that says: if the merge fails, try 
> to fix up these xyz files by just committing them with merge error markers 
> and all".
>
> That's fine for testing, exactly because it has no coding impact (and then 
> when a _real_ merge happens, you have a human that actually resolves it).
> ...
> Git if nothing if not scriptable, and things like this are *trivial*.

You can also use "union" low-level merge driver for such files
via gitattributes(5).
