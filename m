Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbXHEFjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbXHEFjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 01:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXHEFiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 01:38:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:31138 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbXHEFiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 01:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=paDZC7hS3BEk9w0rA65YaGOmhgxWPwoE42UI6+dANp2f8IS6MZBBJOeW/M6haRz2KcoFfxEGbY9rT+9OCsVn3hW7pjnola3QUkQzPgRuSatS1PpRJ/EBHZ0YEyivt36rO1bKKrU9cBBvltSEEs5AlJUf4CryvgIqTU8SUkssquM=
Message-ID: <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com>
Date: Sat, 4 Aug 2007 22:38:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <20070805050410.GB4960@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	 <200708050140.49590.ak@suse.de>
	 <20070805050410.GB4960@rhun.haifa.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> On Sun, Aug 05, 2007 at 01:40:49AM +0200, Andi Kleen wrote:
>
> > Oh what a mess. I think I'll ask Linus to revert the sysdata patch
> > instead. Clearly the stuff is half-baked
>
> By the way, Andi, just making sure you're aware the issue Andy's patch
> addresses is separate from the 2.6.23-rc1 ->sysdata breakage?
> Reverting my and jgarzik's sysdata patch won't fix Andy's issue.
>


OK at this time, you can take my patch
x86_64-get-mp_bus_to_node-as-early-v2.patch
to fix the chuck the problem.

Chuck,
can you try my patch in -mm.
or you can get that from following link
http://lkml.org/lkml/2007/7/26/377

I like to see acpi=off work without problem on AMD64 platform.

YH
