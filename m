Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYB0G3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYB0G3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 01:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYB0G3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 01:29:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:33314 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbYB0G3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 01:29:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U5u+6O38J51GRWMY3T3RyqlXfUDLvuyvzvp7WLwFwC53rq6lNyzjMuZTQ2ijjUiBh0/dq4OtxjewbD5YANf4P0XBDXzZfO4qhpBME6Y2m0Ymtcq1RQuqJ46Noa4sHIgqdRYVDBjiA2oQDwI1attQBJ17MZVC55EcFan05xlrUvg=
Message-ID: <86802c440802262229t37c61c98y45607ba34d7c6417@mail.gmail.com>
Date: Tue, 26 Feb 2008 22:29:02 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing boot failure
Cc: "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "Christoph Lameter" <clameter@sgi.com>,
       "Jack Steiner" <steiner@sgi.com>
In-Reply-To: <20080219192319.GE12386@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	 <20080213175241.GA327@csn.ul.ie> <47B33ACF.5030700@sgi.com>
	 <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com>
	 <20080215020208.GA6500@csn.ul.ie> <47B77E90.5050809@sgi.com>
	 <47BAFFD3.1070606@sgi.com> <20080219192319.GE12386@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 11:23 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On (19/02/08 08:12), Mike Travis didst pronounce:
>
> > Mike Travis wrote:
>  > > Mel Gorman wrote:
>  > >
>  > >> If you send me patches to apply on top of 2.6.25-rc1, I'll give them a spin
>  > >> on the machine in question. Reverting didn't work out very well as there are
>  > >> too many collisions with patches that were applied later. I eventually got
>  > >> the machine booting but it only succeeds because it only brings up one core
>  > >> on each processor.  The patch, which is pretty brain damaged is below in case
>  > >> it helps you guess what the real problem is. dmesg logs are attached of the
>  > >> vanilla failure with acpi=debug and the log with the patch applied showing
>  > >> "__cpu_up: bad cpu 1" and "__cpu_up: bad cpu3" (i.e. the second cores of
>  > >> each machine).
>  > >>
>  > >
>  > > This should completely undo the change to 16 bit apic ids until we can figure
>  > > out the problem with the memory-less nodes.  I checked it on both the numa
>  > > and non-numa x86_64 box.
>  > >
>  > > Thanks,
>  > > Mike
>  > >
>  >
>  > Hi Mel,
>  >
>  > Did you get a chance to try out this patch to see if it cleared up the problem
>  > booting on your x86_64 numa box?

did it fail with x86.git#testing?

YH
