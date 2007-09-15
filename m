Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXIOBbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXIOBbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 21:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbXIOBba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 21:31:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbXIOBb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 21:31:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dan Aloni <da-x@monatomic.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] Add ELF note with Linux version
In-Reply-To: Jeremy Fitzhardinge's message of  Friday, 14 September 2007 14:31:27 -0700 <46EAFDAF.8000809@goop.org>
References: <20070904150018.GA4357@suse.de>
	<46DFD825.2020109@goop.org>
	<20070913144228.2efcd5d9.akpm@linux-foundation.org>
	<20070913221340.GA29181@uranus.ravnborg.org>
	<46E9BD3D.4050102@goop.org>
	<20070914060805.GA32169@uranus.ravnborg.org>
	<46EAE534.5030900@goop.org>
	<20070914210738.GA5031@uranus.ravnborg.org>
	<46EAFDAF.8000809@goop.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070915013052.578554D0424@magilla.localdomain>
Date: Fri, 14 Sep 2007 18:30:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, binutils can be pretty fragile with notes about.  In this case it
> seems to be a specific problem with build-id; I'm not really sure what
> build-id actually does.

The thing about the build ID section that brings up issues with linking is
that it is a SHF_ALLOC, SHT_NOTE section.  As you mentioned, this is a
general, straightforward, and well-defined thing in ELF.  But in practice,
there were not previously SHF_ALLOC note sections used with custom linker
scripts like the kernel's.  (They are used every day in normal executables
and DSOs, but those don't use custom linker scripts.)


Thanks,
Roland
