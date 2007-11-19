Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbXKSVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbXKSVAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXKSVAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:00:33 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:63358 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbXKSVAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:00:32 -0500
Date: Mon, 19 Nov 2007 12:53:30 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, hch@infradead.org, akpm@linux-foundation.org,
       gregkh@suse.de, mucci@cs.utk.edu, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071119205330.GD27571@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071114.152134.266510129.davem@davemloft.net> <18235.40110.831730.847548@cargo.ozlabs.ibm.com> <20071114.172722.71465976.davem@davemloft.net> <20071119.050843.48408777.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119.050843.48408777.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Mon, Nov 19, 2007 at 05:08:43AM -0800, David Miller wrote:
> 
> Instead of blabbering further about this topic, I decided to put my
> code where my mouth is and spent the weekend porting the perfmon2
> kernel bits, and the user bits (libpfm and pfmon) to sparc64.
> 

I appreciate your effort. I am glad to see that the interface
and implementation survived yet another architecture. I think at this
point ARM is the only major architecture missing. In anycase, I would
be happy to integrate your sparc64 patches.

> As a result I've found that perfmon2 is quite nice and allows
> incredibly useful and powerful tools to be written.  The syscalls
> aren't that bad and really I see not reason to block it's inclusion.
> 

As I said earlier, I am not opposed to changing the syscalls. I have
proposed a few schemes to address the issue of versioning. If vectors
arguments are problematic, we can go with single register/call.

I think there are other areas where perfmon2 could benefit from the
help of the LKML developers. I will post a list shortly.

> I rescind all of my earlier objections, let's merge this soon :-)

Thanks.

-- 
-Stephane
