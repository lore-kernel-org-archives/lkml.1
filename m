Return-Path: <linux-kernel-owner+w=401wt.eu-S971937AbXILS0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971937AbXILS0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966616AbXILS02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:26:28 -0400
Received: from mx.treblig.org ([80.68.94.177]:3825 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765544AbXILS01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:26:27 -0400
Date: Wed, 12 Sep 2007 19:26:23 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
Message-ID: <20070912182622.GA16520@gallifrey>
References: <200709071526.51169.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709071526.51169.jesse.barnes@intel.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 18:48:21 up 30 days,  2:03,  1 user,  load average: 2.42, 1.44, 1.14
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes (jesse.barnes@intel.com) wrote:
> FYI, we just released a new white paper describing memory ordering for 
> Intel processors:
> http://developer.intel.com/products/processor/manuals/index.htm
> 
> Should help answer some questions about some of the ordering primitives 
> we use on i386 and x86_64.

Hi Jesse,
  Thanks for letting everyone know about that paper, however - it
has confused me somewhat; there seem to be differences in that
description and that described in the 'Intel 64 and IA-32 Architectures
Software Developer's Manual' and I'd like to understand whether
this paper is designed just to explain points or is actually 
intended to change what can be expected of the processor.

That ordering doc states:
'Loads are not reordered with other loads'

Vol3a section 7.2.1 of the architecture manual states:

'Reads can be carried out speculatively and in any order.'

Is this a:
  1) Change in the definition of the architecture that existing
processors actually follow anyway.
  2) A difference between what the processor does and what is visible
to the software (the intro to this paper does seem to emphasize
software visibility more than the architecture manual).
  3) Some other difference I haven't spotted.

The other thing that made me think about it was that the Itanium
Architecture Software Dev Manul vol2 2.1.2 states that the Itanium
uses ld.acq/st.rel (acquire/release) references to
'operate according to the IA-32 ordering model.' which I think means
that all those loads are in order relative to all the other acquire
loads?

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
