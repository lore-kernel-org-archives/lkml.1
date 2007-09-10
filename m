Return-Path: <linux-kernel-owner+w=401wt.eu-S965725AbXIJWpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965725AbXIJWpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965116AbXIJWp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:45:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62380 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965056AbXIJWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:45:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=mTGwpyaw2uI9zYpTHb3f6RGMl96qboZYNUFwAjK4vM7OtIMrhdN7tpvy5EvqzJqIo
	w3I+xR/oLomhUqOqyK/tg==
Message-ID: <6599ad830709101545s66fd338dob6932407db4e1002@mail.gmail.com>
Date: Mon, 10 Sep 2007 15:45:15 -0700
From: "Paul Menage" <menage@google.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Cc: vatsa@linux.vnet.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <b647ffbd0709101537l9af4dc8x743b25c96e0f5235@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070910171049.GA16048@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
	 <20070910172334.GB19100@linux.vnet.ibm.com>
	 <20070910102259.dc45a481.akpm@linux-foundation.org>
	 <20070910174649.GA16222@linux.vnet.ibm.com>
	 <b647ffbd0709101537l9af4dc8x743b25c96e0f5235@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/07, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> On 10/09/2007, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> > On Mon, Sep 10, 2007 at 10:22:59AM -0700, Andrew Morton wrote:
> > > objection ;)  "cpuctlr" isn't memorable.  Kernel code is write-rarely,
> > > read-often.  "cpu_controller", please.  The extra typing is worth it ;)
> >
> > Ok! Here's the modified patch (against 2.6.23-rc4-mm1).
>
> as everyone seems to be in a quest for a better name... I think, the
> obvious one would be just 'group_sched'.
>

But "sched" on its own could refer to CPU scheduling, I/O scheduling,
network scheduling, ...

And "group" is more or less implied by the fact that it's in the
containers/control groups filesystem.

So "group_sched" isn't really all that informative. The name should
definitely contain either "cpu" or "cfs".

Paul
