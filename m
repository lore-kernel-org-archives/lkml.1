Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYIZUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYIZUho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYIZUhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:37:36 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47040 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbYIZUhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:37:36 -0400
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
From: Zachary Amsden <zach@vmware.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alok Kataria <akataria@vmware.com>,
       Alok kataria <alokkataria1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <40178.1222435332@turing-police.cc.vt.edu>
References: <20080221115452.GB13948@elte.hu>
	 <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu>
	 <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>
	 <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1>
	 <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1>
	 <48DB1BCE.2070106@zytor.com> <1222320201.23524.135.camel@alok-dev1>
	 <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com>
	 <48DC09D9.7040204@zytor.com>
	 <1222381254.27056.194.camel@bodhitayantram.eng.vmware.com>
	 <48DC105D.9050803@zytor.com>            <48DCD9D9.9080008@redhat.com>
	 <40178.1222435332@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 13:35:48 -0700
Message-Id: <1222461348.27056.201.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 06:22 -0700, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 26 Sep 2008 14:47:21 +0200, Gerd Hoffmann said:
> >   Hi,
> > 
> > > This, of course, is what CPUID is for.
> > 
> > ... except that it doesn't always work.  It requires vmx/svm, otherwise
> > cpuid doesn't trap and thus can't be filled by the hypervisor ...
> 
> Which would be hardware implementers in the '80s getting wrong the first few
> times what IBM did right the first time.  Doesn't *anybody* do literature
> searches before doing stuff anymore? ;)

>From your description, IBM also did it wrong the first time.  Having an
instruction which operates differently when running on bare metal vs. in
a hypervisor is never acceptible unless the instruction is trappable.

There will always be a guest which refuses to operate propely in a
hypervisor, either by defect or by design, so 'sensitive' instructions
should always be trappable.  Do it right and you can nest recursively ;)

Zach

