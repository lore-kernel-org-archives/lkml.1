Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbXFQV4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbXFQV4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXFQV4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:56:09 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:49088 "EHLO
	viefep28-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752423AbXFQV4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:56:08 -0400
Date: Sun, 17 Jun 2007 23:55:58 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617215558.GB6207@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617213355.GC3430@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 05:33:55PM -0400, Dave Jones wrote:
>  > What would the name be of such module?
> 
> intel-agp
> 
> Though by the looks of things, with the working kernel, you don't have
> it loaded (it's dependant upon the 'agpgart' module, which prints the
> "Detected" line that was missing).

hikaru:~>lsmod | grep agp
intel_agp              31776  0

It's loaded right now... that is with 2.6.22-rc4-+something (one of the
working ones).  I don't know WHEN it was loaded though. Probably
not at the same time as the others. 

And

hikaru:~>dmesg | grep agpgart
Linux agpgart interface v0.102 (c) Dave Jones

No 'Detected' line :/

Also, I noted that this 'agpgart: Detected..' line is always(?) printed
right after (often even without THAT line having printed a newline yet!)
something like:

udev: Waiting for /dev to be fully populated...agpgart: Detected an Intel 965G Chipset.

And this 'udev: Waiting for /dev to be fully populated' (sorry, didn't
write down the exact phrase, this is from memory) is also not printed
by kernels that work.

-- 
Carlo Wood <carlo@alinoe.com>

PS I asked you move to the other thread - it's a bit annoying to have
two threads about this now.

