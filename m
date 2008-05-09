Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbYEIR2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbYEIR2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761201AbYEIR2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:28:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:30977 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761072AbYEIR2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MwZNjyB2YIE+ILTs3lyvt54XRoef8iT8HXIyoXXu9F9t4NnWf6bIOrue7P2On1LVcfX5cVMzJYKe69NTWyDfaWXqg2LzKQufI/C2789dq3dx0ExuZNVL31Ub0eOmtDuy9wbqbDr0G3KHplNVDWPLb0Bo2iMvqcexLqv8W6ypV+M=
Subject: Re: [PATCH 5/9] frv: gdb-stub.c use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <14697.1210334828@redhat.com>
References: <1209694461.24729.223.camel@brick>
	 <1209683136.24729.207.camel@brick> <11442.1209694140@redhat.com>
	 <14697.1210334828@redhat.com>
Content-Type: text/plain
Date: Fri, 09 May 2008 10:28:03 -0700
Message-Id: <1210354083.24092.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 13:07 +0100, David Howells wrote:
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Everyone rolls their own version around the tree, centralize
> > in lib/hexdump.c
> 
> Can you instruct that these are only to be used for GDB stubs?  Otherwise if
> someone slaps a breakpoint in there accidentally, they might kill the GDB
> stub.
> 

This isn't a problem for hex_asc_{hi|lo} obviously, just the
hexchar_to_int function, I've been looking at making this available in
another way due to its similarity to simple_strtol etc (akpm noticed).

So the hex_asc_hi/lo helpers are probably useful as-is.  I'll make
sure to note the effects on gdb as you've pointed out when I send
out the revised usage.

Cheers,

Harvey

