Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbYHNRjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbYHNRjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYHNRi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:38:59 -0400
Received: from gw.goop.org ([64.81.55.164]:55331 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYHNRi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:38:58 -0400
Message-ID: <48A46D98.1010607@goop.org>
Date: Thu, 14 Aug 2008 10:38:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
References: <1218697362.26014.9.camel@localhost.localdomain> <Pine.LNX.4.64.0808141347480.11013@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808141347480.11013@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> In both cases it's handling a page fault: I'm curious as to what kind
> of vma this fault is occurring on.  Could you devise a way of getting
> us /proc/<pid>/maps output, together with the faulting address, when
> it hits one of these BUGs?  Or should I try to put together a patch
> for that?
>   

Irritatingly, it looks like the i386 register dump doesn't include cr2.  
My 64-bit dump has cr2 as 00007fb12cb2a000 which is a good solid 
usermode address.  I'll run X under strace to see if that gives a clue 
to what it corresponds to.

    J
