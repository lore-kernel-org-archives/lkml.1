Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYHAPrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYHAPrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYHAPrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:47:15 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:24838 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbYHAPrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:47:14 -0400
In-Reply-To: <20080801052936.GZ20457@bakeyournoodle.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Sam Ravnborg <sam@ravnborg.org>
MIME-Version: 1.0
Subject: Re: [BUILD-FAILURE] 2.6.27-rc1-mm1 - allyesconfig build fails on powerpc
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFD20F5EDA.300B66D1-ONC1257498.00561E0E-C1257498.00567026@de.ibm.com>
From: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Date: Fri, 1 Aug 2008 17:44:07 +0200
X-MIMETrack: Serialize by Router on D12ML066/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 01/08/2008 17:46:28,
	Serialize complete at 01/08/2008 17:46:28
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Breeds <tony@bakeyournoodle.com> wrote on 01.08.2008 07:29:36:

> On Thu, Jul 31, 2008 at 06:13:28PM +0530, Kamalesh Babulal wrote:
> > Hi Andrew,
> > 
> > make allyesconfig with 2.6.27-rc1-mm1 kernel on powerpc fails with
> build error
> 
> <snip>
> 
> Turning off GCOV "fixes" this.  Not really the best solution but at
> least it narrows doen the search effort.
> 
> Peter,
>    Can you have a look at how this can be fixed, if at all?

I did some testing with a cross-compiler myself and I don't think
there is a general solution to this problem. It's not one particular
file that is causing the problem but seemingly the sheer size of the
resulting vmlinux file - even though the toal vmlinux.o size is
"merely" up about 100MiB (from around 1,03Gib to 1,13Gib).

I think I'll need help from people with knowledge of the powerpc
toolchain here.


Regards,
  Peter
