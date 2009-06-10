Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbZFJTpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbZFJTpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758757AbZFJTpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:45:32 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:45213 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZFJTpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mnGgbwE/FJYXyiH23w4sgPN+RWPZM9dDjir+68T40b6zo+87rde+RH7HxUIl+U20yT
         SX0yWSbfXNn+IArwN45s6bc0+49FgRU2cvdz3B0Kc8S79u6MJeIbv5ON/Nq7CfIzJWbe
         yG8azwW9CD2KeHmiljncIXNNjYHChj0u+LbYY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906101523140.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org> 
	<1244623722-6325-2-git-send-email-vapier@gentoo.org> <alpine.DEB.2.00.0906101303560.30552@gandalf.stny.rr.com> 
	<8bd0f97a0906101131m2fc21f75uc174631150897e5e@mail.gmail.com> 
	<alpine.DEB.2.00.0906101441410.30552@gandalf.stny.rr.com> 
	<8bd0f97a0906101207s3eb36ccbp7baa631a941b9b0f@mail.gmail.com> 
	<alpine.DEB.2.00.0906101511070.30552@gandalf.stny.rr.com> 
	<8bd0f97a0906101219r7a7fcbdfqc0c45c9c97210d1a@mail.gmail.com> 
	<alpine.DEB.2.00.0906101523140.30552@gandalf.stny.rr.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 10 Jun 2009 15:45:13 -0400
Message-ID: <8bd0f97a0906101245h100e1c13v5f1b189995d6464d@mail.gmail.com>
Subject: Re: [PATCH 2/2] ftrace: document basic ftracer/ftracer graph needs
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 15:34, Steven Rostedt wrote:
>> ones, as is the core ftrace code wrt the arch pieces it relies on.
>> the absolute dearth of ftrace documentation for arch porters is
>> ridiculous.
>
> Yes, we can always document more. But you are the first to complain to me
> about lack of documentation for porting. I get complaints all the time
> about lack of documentation for using it, and I'm working on that.

imo, it should be a given that when a framework or common feature is
added which requires some kind of arch support, what exactly is
required of the arch should be clearly spelled out.  having an arch or
two implement said feature is useful sometimes as an example, but it
is rarely (if ever) a good place to find out details.  more time is
spent basically reverse engineering the (unfamiliar) arch details.

this isnt a complaint specific to ftrace btw, so it's more of a
general hair pulling mini rant.

> When I get time, I would love to write up a "how to port ftrace" doc.
>
> I would also love to review one ;-)

well ive already done the footwork for the basic options, so i'm
starting the documentation now by moving the Kconfig stuff i posted
there.  but it'll be missing info on:
HAVE_FTRACE_NMI_ENTER
HAVE_FTRACE_SYSCALLS
HAVE_FTRACE_MCOUNT_RECORD
HAVE_DYNAMIC_FTRACE

personally i dont care about NMI as the Blackfin arch's handling of
NMI is pretty much useless to Linux, but i would be interested in the
other three
-mike
