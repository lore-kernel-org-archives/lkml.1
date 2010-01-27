Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862Ab0A0EvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0A0EvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 23:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726Ab0A0EvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 23:51:19 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:46883 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab0A0EvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 23:51:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=B2bFFvTcxYeFJzVfdx4d/tWK+hKghqHcbzYlhZsRip2x62wsfRj9+oeiiolTHtaHrC
         Fa4DHjtY35jwebjr9qR0koTjLLLs0DJxsDWrKhk67kthNb0uZ1zBv89Yd9nmXQE/7C5x
         mG6VOMykPgvoC5wk6a0mDNBM0xm1Me4feGhRw=
MIME-Version: 1.0
In-Reply-To: <1264170977.31321.382.camel@gandalf.stny.rr.com>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org> 
	<1264170977.31321.382.camel@gandalf.stny.rr.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 26 Jan 2010 23:50:58 -0500
Message-ID: <8bd0f97a1001262050g1b6ce455o4b767251c8bebc95@mail.gmail.com>
Subject: Re: [PATCH] ftrace: unify arch_syscall_addr() implementations
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 09:36, Steven Rostedt wrote:
> On Fri, 2010-01-22 at 08:43 -0500, Mike Frysinger wrote:
>> Every arch_syscall_addr() implementation thus far is the same, so unify
>> them as a default weak in common code so more arches don't have to waste
>> time copying & pasting this simple function.  The Blackfin version is
>> going to be exactly the same.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> note: only thing that needs double checking is s390 and sparc where they
>> declared the sys_call_table as an array of ints.  considering this table
>> is supposed to be an array of function pointers, this seems like more of
>> a typo to me ...
>
> I would not be too sure. s390 is very strange, and I would definitely
> want to get an Ack from the arch maintainers first.

i think everyone has checked in with v3 ...
-mike
