Return-Path: <linux-kernel-owner+w=401wt.eu-S1751641AbXA2Pj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbXA2Pj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbXA2Pj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:39:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbXA2Pj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:39:57 -0500
Message-ID: <45BE1561.6000303@redhat.com>
Date: Mon, 29 Jan 2007 10:40:17 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] i386: add option to show more code in oops reports
References: <45B7C019.1040209@redhat.com> <20070125145504.c8c0a98a.akpm@osdl.org> <45B943B7.8070500@redhat.com> <200701290444.21861.ak@suse.de>
In-Reply-To: <200701290444.21861.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Friday 26 January 2007 00:56, Chuck Ebbert wrote:
>
>   
>> Can't think of a way to word the justification, but I've wanted to see more
>> code a few times.
>>     
>
> Hmm, not sure I see the point. The Code line is just that you can
> make sense of random mailing list oopses where you don't
> have a vmlinux. But as long as you don't make the option
> the default you would need to ask people to set it for you -- and when you
> ask you could always as well ask about the vmlinux and get
> as much code as you ever wanted.
>   
This was patch inspired by my finding out that code in the running
kernel might have
been modified at runtime by some strange bug, and looking at vmlinux
might not be
helpful.

See:
    http://lkml.org/lkml/2007/1/24/143
> So unless it's default it's likely useless and I don't think
> it is a good idea to make it default because oops screen estate
> is so precious.
>   
Yeah, there's no way it could be the default. But I'd like to see if
Alistair John Strachan's
running kernel matches the vmlinux he posted with that strange
unexplained oops.
