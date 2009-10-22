Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZJVQVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZJVQVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZJVQVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:21:07 -0400
Received: from mail-a02.ithnet.com ([217.64.83.97]:60625 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754917AbZJVQVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:21:07 -0400
X-Sender-Authentication: net64
Date: Thu, 22 Oct 2009 18:21:06 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: include/asm-generic/int-ll64.h kernel 2.6.31.4
Message-Id: <20091022182106.3bdf7b5d.skraw@ithnet.com>
In-Reply-To: <200910221629.59818.arnd@arndb.de>
References: <20091020154305.8338b765.skraw@ithnet.com>
	<200910221629.59818.arnd@arndb.de>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 16:29:59 +0200
Arnd Bergmann <arndbergmann@googlemail.com> wrote:

> On Tuesday 20 October 2009, Stephan von Krawczynski wrote:
> > I lately compiled some app that stumbled across this, and someone smarter than
> > me should judge if this is right or wrong:
> > 
> > 
> > * asm-generic/int-ll64.h
> >  *
> >  * Integer declarations for architectures which use "long long"
> >  * for 64-bit types.
> >  */
> > 
> > #ifndef _ASM_GENERIC_INT_LL64_H
> > #define _ASM_GENERIC_INT_LL64_H
> > 
> > #include <asm/bitsperlong.h>
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > 
> > Is it correct to include from linked "asm" instead of asm-generic ?
> > 
> > My link goes to "asm-x86" but for some reason asm-generic/types.h is included
> > which ends at int-ll64.h trying to include a not existing bitsperlong.h from
> > directory asm-x86.
> 
> Hi Stephan,
> 
> Most likely you are using the kernel headers in an unsupported way, like
> trying to point to $(HOME)/linux-2.6/include for include files when building
> an application.
> 
> Please see http://kernelnewbies.org/KernelHeaders for how to fix that.
> 
> 	Arnd <><

I am the wrong person to tell that, the story belongs to keepalived.
Nevertheless reading other header files in the same dir makes me think that
pointing to "asm" instead of "asm-generic" looks flakey, or why do others
point to -generic then?

-- 
Regards,
Stephan
