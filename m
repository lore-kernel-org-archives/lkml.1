Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbXEYPks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbXEYPks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 11:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbXEYPkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 11:40:41 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:55361 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbXEYPkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 11:40:40 -0400
X-IronPort-AV: i="4.14,580,1170662400"; 
   d="scan'208"; a="157562650:sNHT45964476"
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
X-Message-Flag: Warning: May contain useful information
References: <20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<20070525052032.GB9386@suse.de>
	<m1myztaq5s.fsf@ebiederm.dsl.xmission.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 25 May 2007 08:40:38 -0700
In-Reply-To: <m1myztaq5s.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's message of "Fri, 25 May 2007 09:17:35 -0600")
Message-ID: <adawsyw52tl.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 May 2007 15:40:38.0489 (UTC) FILETIME=[0B21FC90:01C79EE3]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > - In spec hardware does not require MSI to generate interrupts
 >   Which leaves enabling MSI optional.

Actually at least the Qlogic/Pathscale PCI Express ipath adapters
cannot generate INTx interrupts -- they definitely do require MSI to
operate.

 - R.
