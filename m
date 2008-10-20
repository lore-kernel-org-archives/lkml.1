Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYJTRmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYJTRmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYJTRmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:42:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:47963 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYJTRml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VTuAaeSuhQ7oOFaOgn6IoFYjLAVvT1xhF1NqXDgihIbAuNLdFwldy+EvYKhe6DBk6h
         7xYY8tOKq8VFqpP7mjco8aJ4FjpQNanLCKk5HwBK6GS1A2nwQz3NlLk+bO/OtYZLqBdT
         Y5i6RFWURhx5pr/gCMZn9VbdaiMYMDVwccoF8=
Message-ID: <c62985530810201042v4b3eed0ah62de285c64b2c0ba@mail.gmail.com>
Date: Mon, 20 Oct 2008 19:42:38 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20081020170808.GB7249@yoda.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080906050602.409299112@goodmis.org>
	 <20080906120346.GA30964@elte.hu>
	 <20081016181452.GA29739@yoda.jdub.homelinux.org>
	 <alpine.DEB.1.10.0810161421530.11042@gandalf.stny.rr.com>
	 <20081016183529.GB29739@yoda.jdub.homelinux.org>
	 <alpine.DEB.1.10.0810161444050.11042@gandalf.stny.rr.com>
	 <20081016150106.6ddf7e46@zod.rchland.ibm.com>
	 <alpine.DEB.1.10.0810201222570.3760@gandalf.stny.rr.com>
	 <20081020170808.GB7249@yoda.jdub.homelinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/20 Josh Boyer <jwboyer@linux.vnet.ibm.com>:
> That seems like a good plan.  Should we mark dynamic ftrace as X86 only
> in Kconfig for .28 to prevent people from inadvertently setting it?

Hi Josh.

There are other arch that support ftrace as well like sh or sparc64
(I'm currently working on
an implementation for mips).
So the choice would be better between waiting for a fix or disable
dynamic ftrace
on Kconfig only for PowerPC.
