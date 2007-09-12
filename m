Return-Path: <linux-kernel-owner+w=401wt.eu-S1764944AbXILLXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764944AbXILLXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764723AbXILLXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:23:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53239 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764577AbXILLXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:23:01 -0400
Date: Wed, 12 Sep 2007 16:53:08 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux-arch@vger.kernel.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] Extended crashkernel command line
Message-ID: <20070912112308.GA17436@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070909083914.065380136@strauss.suse.de> <20070909083914.488571169@strauss.suse.de> <20070911061522.GD5053@in.ibm.com> <20070911100110.GB31038@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911100110.GB31038@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 12:01:10PM +0200, Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-09-11 08:15]:
> > 
> > "offset" seems to be optional in the new syntax. What happens if user does
> > not specify offset. I think crash_base will be set to zero and system will
> > try to reserve x amount of memory start at zero? That would fail?
> 
> That's handled in the architecture specific code -- because it's
> different on each architecture and the architecture specific code does
> memory reservation. IA64 already can handle this case (on IA64,
> specifying 0 is the same than leaving out the base address, and that's
> why I wanted to keep that semantics). I think it doesn't also make
> sense on i386/x86_64 to choose 0 as real base address, because the
> value below 1 MB is special for booting ...
> 

Ok. I see IA64 is handling this case. But in current patchset, i386 and
x86_64 will try to reserve memory starting at zero?  So we still got
to handle this case in i386 and x86_64?

Thanks
Vivek
