Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbXDLW5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbXDLW5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXDLW5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:57:32 -0400
Received: from gw.goop.org ([64.81.55.164]:49802 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXDLW5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:57:31 -0400
Message-ID: <461EB938.6080807@goop.org>
Date: Thu, 12 Apr 2007 15:56:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org> <200704122321.23318.ak@suse.de>
In-Reply-To: <200704122321.23318.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> (This was under Xen, but there's no reason it couldn't happen on bare
>>   hardware.)
>>     
>
> Hmm, does Xen perhaps not use interrupt stacks?

Looks like that's all done in do_IRQ, so it should be independent of
whether its Xen or not.  And the stack overflow check is performed on
the main stack, before switching to the interrupt stack.

    J
