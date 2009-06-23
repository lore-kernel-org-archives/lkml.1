Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbZFWW4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbZFWW4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZFWWz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:55:59 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59432 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZFWWz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:55:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 15:49:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, avi@redhat.com,
       kvm@vger.kernel.org, ghaskins@novell.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
In-Reply-To: <20090623144416.04c34268.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906231538280.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com> <20090623131239.711d9f83.akpm@linux-foundation.org> <alpine.DEB.1.10.0906231355130.17001@makko.or.mcafeemobile.com>
 <20090623142511.c9068655.akpm@linux-foundation.org> <alpine.DEB.1.10.0906231423490.17001@makko.or.mcafeemobile.com> <20090623144416.04c34268.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Andrew Morton wrote:

> On Tue, 23 Jun 2009 14:25:05 -0700 (PDT)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > On Tue, 23 Jun 2009, Andrew Morton wrote:
> > 
> > > That isn't for us to decide. Entire syscalls can be disabled in config.
> > 
> > That is not a well defined separate syscall though. It's a member/feature 
> > of the aiocb.
> 
> I don't know what this means, really.

This is the struct iocb:

struct iocb {
	...
	u_int32_t       aio_resfd;
};

And the only interface to access KAIO is io_submit().
IMO the end user perceives the KAIO functionality as the full deployment 
of the iocb struct and the io_submit() accessory.
Can code not using eventfd work in (AIO && !EVENTFD) mode? Sure.
It is a kinda confusing configuration from the end user POV IMO.



- Davide


