Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbXEYFv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbXEYFv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXEYFvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:51:52 -0400
Received: from mx1.suse.de ([195.135.220.2]:60608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbXEYFvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:51:51 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Date: Fri, 25 May 2007 07:51:45 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@ninex.eu.org>, ninex@o2.pl,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com> <20070524213157.1d39458f.akpm@linux-foundation.org>
In-Reply-To: <20070524213157.1d39458f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705250751.45738.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Do we have a feel for how much performace we're losing on those 
> systems which _could_ do MSI, but which will end up defaulting
> to not using it?

At least on 10GB ethernet it is a significant difference; you usually
cannot go anywhere near line speed without MSI

I suspect it is visible on high performance / multiple GB NICs too.

-Andi
