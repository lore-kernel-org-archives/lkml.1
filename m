Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbYGRLcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbYGRLcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYGRLc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:32:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54259
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758094AbYGRLcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:32:24 -0400
Date: Fri, 18 Jul 2008 04:32:24 -0700 (PDT)
Message-Id: <20080718.043224.42319074.davem@davemloft.net>
To: andi@firstfloor.org
Cc: roland@redhat.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
From: David Miller <davem@davemloft.net>
In-Reply-To: <87vdz3qvta.fsf@basil.nowhere.org>
References: <20080717072541.F390E15411D@magilla.localdomain>
	<20080718.022035.208722773.davem@davemloft.net>
	<87vdz3qvta.fsf@basil.nowhere.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Fri, 18 Jul 2008 13:24:33 +0200

> David Miller <davem@davemloft.net> writes:
> >
> > The other arch's with compat support will have this same exact issue.
> 
> On x86-64 the sign extension is in C code, so it would be somewhat more
> complicated to do a generic table or converter.

I was suggesting to use the list of syscalls in the sparc64 code
in a generic spot, making a table indexed by __NR_* number
that the tracehook syscall stuff can use.

But yes, there are other issues such as datastructure layout.

It all depends upon what Roland thinks those arg values obtained by
the asm/syscall.h functions should mean.

