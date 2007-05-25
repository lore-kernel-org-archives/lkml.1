Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbXEYP2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbXEYP2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 11:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbXEYP2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 11:28:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbXEYP2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 11:28:47 -0400
Message-ID: <4657008F.903@redhat.com>
Date: Fri, 25 May 2007 11:28:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
References: <20070514093829.377e04bc@osprey.hogchain.net>	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>	<20070514160005.627435e3@osprey.hogchain.net>	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>	<20070515212200.517fcba2@osprey.hogchain.net>	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>	<20070516185225.3f3ac082@osprey.hogchain.net>	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>	<20070522204103.134bf5a2@osprey.hogchain.net>	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>	<20070525052032.GB9386@suse.de> <m1myztaq5s.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1myztaq5s.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2007 11:17 AM, Eric W. Biederman wrote:
> 
> MSI appears to have enough problems that enabling it in a kernel
> that is supposed to run lots of different hardware (like a distro
> kernel) is a recipe for disaster.

Ubuntu and Fedora have disabled it and added a "pci=msi" option
to enable it if required.
