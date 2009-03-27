Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbZC0UpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbZC0UpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZC0Uov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:44:51 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:60043 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZC0Uou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:44:50 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_Wn0CgGdPuzRyi+GptxCrXA)"
Date: Fri, 27 Mar 2009 16:44:33 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: linux-next: Tree for March 27 (longhaul build error)
In-reply-to: <200903271842.37665.bzolnier@gmail.com>
Message-id: <alpine.LFD.2.00.0903271644040.26419@localhost.localdomain>
References: <20090327231924.4e4168c5.sfr@canb.auug.org.au>
 <200903271842.37665.bzolnier@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_Wn0CgGdPuzRyi+GptxCrXA)
Content-type: TEXT/PLAIN; charset=utf-8
Content-transfer-encoding: 8BIT


On Fri, 27 Mar 2009, Bartlomiej Zolnierkiewicz wrote:

> 
> Hi,
> 
> On Friday 27 March 2009, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090326:
> 
> I hit the following build error using OpenSUSE's kernel config:
> 
> arch/x86/kernel/cpu/cpufreq/longhaul.c: In function ‘longhaul_setstate’:
> arch/x86/kernel/cpu/cpufreq/longhaul.c:308: error: implicit declaration of function ‘acpi_set_register’
> make[1]: *** [arch/x86/kernel/cpu/cpufreq/longhaul.o] Error 1
> make: *** [arch/x86/kernel/cpu/cpufreq/longhaul.o] Error 2
> 
> Len, it seems like the following patch managed to slip through the cracks:
> 
> 	http://patchwork.kernel.org/patch/12715/

Got it,
thanks Bart.

Len Brown, Intel Open Source Technology Center

--Boundary_(ID_Wn0CgGdPuzRyi+GptxCrXA)--
