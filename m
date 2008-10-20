Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbYJTVr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbYJTVr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYJTVrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:47:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:65432 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYJTVrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IG8VH6AT33qHctzA9F4A0fybumdVQlarI/+UhHA9M71Xa5kGQDd9VvZdlD9RTZmunN
         2q89dXeY4noHXe0BCh+NCrgOPmlTVD25RIVaHcJvyTyqGCJpi1+ny2mOa8WWNc4gqCtY
         z1Iu4IWCLugDYG38PEdtI3nyRupGu2nHSGB2g=
Message-ID: <c62985530810201447w10423125wb5800c004de6a73c@mail.gmail.com>
Date: Mon, 20 Oct 2008 23:47:45 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
Cc: "Josh Boyer" <jwboyer@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.1.10.0810201351130.5336@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080906050602.409299112@goodmis.org>
	 <20081016181452.GA29739@yoda.jdub.homelinux.org>
	 <alpine.DEB.1.10.0810161421530.11042@gandalf.stny.rr.com>
	 <20081016183529.GB29739@yoda.jdub.homelinux.org>
	 <alpine.DEB.1.10.0810161444050.11042@gandalf.stny.rr.com>
	 <20081016150106.6ddf7e46@zod.rchland.ibm.com>
	 <alpine.DEB.1.10.0810201222570.3760@gandalf.stny.rr.com>
	 <20081020170808.GB7249@yoda.jdub.homelinux.org>
	 <c62985530810201042v4b3eed0ah62de285c64b2c0ba@mail.gmail.com>
	 <alpine.DEB.1.10.0810201351130.5336@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/20 Steven Rostedt <rostedt@goodmis.org>:
> I believe MIPS has the same issues as PPC. Doesn't it use a trampoline
> too?

No it doesn't seem to. If I'm not wrong, MIPS uses only the elf
relocation table to relocate
its addresses.

> I want to make the generic code handle trampolines a bit better.

Do you think there could be a generic approach to handles these trampolines?
