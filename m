Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXCPLiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXCPLiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933586AbXCPLiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:38:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42610 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583AbXCPLiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:38:13 -0400
Date: Fri, 16 Mar 2007 17:08:01 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Ian Campbell <Ian.Campbell@xensource.com>, Horms <horms@verge.net.au>,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070316113801.GC5642@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1173961378.8591.63.camel@localhost.localdomain> <20070315132616.GH6766@in.ibm.com> <20070315234807.GB10861@verge.net.au> <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com> <1174030097.28658.37.camel@localhost.localdomain> <aec7e5c30703160059u108d984dt6bfb831603a887c5@mail.gmail.com> <1174035001.28658.61.camel@localhost.localdomain> <aec7e5c30703160220i3e8a03cbh431622975acbe72d@mail.gmail.com> <20070316093542.GB5642@in.ibm.com> <aec7e5c30703160305p5d91af41h147e3a6c2687bcd9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30703160305p5d91af41h147e3a6c2687bcd9@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 07:05:30PM +0900, Magnus Damm wrote:
> On 3/16/07, Vivek Goyal <vgoyal@in.ibm.com> wrote:
> >Got a question. When running 32bit dom0 on 64bit hypervisor, which
> >kexec-tools elf loader will kick in? 32bit or 64bit? Looks like in this
> >case 64bit one. But shouldn't it be 32bit as 32bit OS is running and we
> >must be using the kexec-tools binary compiled for 32bit OS? And if 32bit
> >loader kicks in we will not be passing any acpi parameters.
> 
> There is no check to see if the hypervisor is 32 or 64 bits present
> today. So the 32-bit version of kexec-tools will support loading
> images like any other 32-bit kexec-tools.
> 

If that is the case then in prepared elf headers, machine type should
be EM_386 or similar and not EM_X86_64 and Ian shouldn't have run into
the problem at all with vmcore. Am I missing something?

Thanks
Vivek
