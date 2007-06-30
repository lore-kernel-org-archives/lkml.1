Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbXF3OUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbXF3OUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbXF3OUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:20:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:45265 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006AbXF3OUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XiQINljiIp3FcTNKw6mEI+ZwuaAqj6sot4MKmS/Uzya4/SxK0IsZAg8tKfoRwKAvMJpMhHPSAIwHzoYyYhpvfJEP7OHWhhFngbxrImvqzVcuUunqJogROQOQEgFRmMr5TrtK8Pp6/8K/CzZg4+7NaQa0IqCAcI2wjlvDwFQXJfk=
Message-ID: <a781481a0706300720p74f08085t55653b007431685f@mail.gmail.com>
Date: Sat, 30 Jun 2007 19:50:41 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
Subject: Re: sh section mismatches [was Re: 2.6.22-rc6 on Dreamcast (SH4)]
Cc: "Mike Frysinger" <vapier@gentoo.org>, linuxsh-dev@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <1183210853.6016.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0706280457r4abb5046wc82cff9d49b7975e@mail.gmail.com>
	 <1183210853.6016.2.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/30/07, Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:
> [...]
> WARNING: drivers/built-in.o(.text+0x168e0): Section mismatch: reference
> to .init.data: (between 'pvr2fb_check_var' and 'pvr2fb_interrupt')
> WARNING: drivers/built-in.o(.text+0x1701c): Section mismatch: reference
> to .init.data: (between 'pvr2fb_pci_probe' and 'read_mem')
> WARNING: drivers/built-in.o(.text+0x17024): Section mismatch: reference
> to .init.text: (between 'pvr2fb_pci_probe' and 'read_mem')
> WARNING: drivers/built-in.o(.data+0x738): Section mismatch: reference
> to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
> WARNING: drivers/built-in.o(.data+0x750): Section mismatch: reference
> to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')

Right, as Mike just said, these warnings are the ones from
drivers/video/pvr2fb.c which the patch didn't touch ... that was only
to get rid of the "(between 'mv_dreamcast' and 'systemasic_int')"
warning. But of course, we can't be too sure about the patch till
you can boot and run the system ...

Meanwhile I'll look into Sam's suggestion and try to fix the pvr2fb
warnings too.

Satyam

[ BTW I really wish someone from linux-sh would address that
.machvec.init vs .init.machvec section thing in the earlier mail. ]
