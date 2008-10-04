Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbYJDFp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbYJDFp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 01:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYJDFpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 01:45:17 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:35322 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbYJDFpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 01:45:15 -0400
Subject: Re: kexec with vmware esx 3.0.2
From: Zachary Amsden <zach@vmware.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>, Alok Kataria <akataria@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>
In-Reply-To: <86802c440810031645m5a09c243se072cbcc6f2a151d@mail.gmail.com>
References: <86802c440810031408i60e2036ax805bfd997092cd86@mail.gmail.com>
	 <1223068893.7330.117.camel@bodhitayantram.eng.vmware.com>
	 <86802c440810031440o59359f30ka72230b4b0ff73e@mail.gmail.com>
	 <1223070521.7330.122.camel@bodhitayantram.eng.vmware.com>
	 <86802c440810031458s1ce79589s2448aa0869a74e21@mail.gmail.com>
	 <1223071731.7330.127.camel@bodhitayantram.eng.vmware.com>
	 <86802c440810031551g246232c9n520ef43c6881b8af@mail.gmail.com>
	 <1223074735.7330.138.camel@bodhitayantram.eng.vmware.com>
	 <86802c440810031645m5a09c243se072cbcc6f2a151d@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 22:41:25 -0700
Message-Id: <1223098885.7330.157.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 16:45 -0700, Yinghai Lu wrote:
> On Fri, Oct 3, 2008 at 3:58 PM, Zachary Amsden <zach@vmware.com> wrote:
> > On Fri, 2008-10-03 at 15:51 -0700, Yinghai Lu wrote:
> >
> >> ok, my question is: anyone tried to use kexec with vmware?
> >
> > Do you mean has anyone tried to use kexec in Linux running under VMware,
> 
> that should work

It does.

> > or do you mean has anyone tried to use kexec to start ESX?
> 
> yeah, that is strange request. hope it work..

Well you're a braver soul than me.  If your hardware is really so horked
you can't boot Linux without noacpi, I seriously doubt the vmkernel will
run properly.  You might be able to kexec the Linux pre-bootstrapping
bit, the the vmkernel is not even close to the same code lineage and has
a limited and very fixed set of hardware requirements.  And you are
talking about fixing up the MP table and interfering with the custom
boot process?  I would not for any amount of money want to find out what
kind of squirrels are hiding in that nest.

I mean can you run Oracle on an overclocked budget brand laptop?  Well,
maybe.

But you're talking about running an enterprise class application on
dodgy hardware, and that is seriously stretching the realms of sanity.

I kinda don't think this is really interesting to the folks on LKML, you
could try asking over on the VMware forums.

Good luck,

Zach

