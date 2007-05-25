Return-Path: <linux-kernel-owner+w=401wt.eu-S1764950AbXEYVRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764950AbXEYVRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXEYVRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:17:19 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:53337 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbXEYVRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:17:18 -0400
X-IronPort-AV: i="4.14,581,1170662400"; 
   d="scan'208"; a="2726977:sNHT119695068"
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
References: <20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<20070525052032.GB9386@suse.de>
	<m1myztaq5s.fsf@ebiederm.dsl.xmission.com>
	<20070525203501.GD5413@suse.de>
	<m1k5uwaa0h.fsf@ebiederm.dsl.xmission.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 25 May 2007 14:17:07 -0700
In-Reply-To: <m1k5uwaa0h.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's message of "Fri, 25 May 2007 15:06:22 -0600")
Message-ID: <adatzu038oc.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 May 2007 21:17:08.0085 (UTC) FILETIME=[0D11DA50:01C79F12]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I think for most of Intel I can reduce my test to:
 > If (bus == 0 , device == 0, function == 0 && vendor == Intel &&
 >     has a pci express capability) {
 > 	Enable msi on all busses().
 > }

MSI was working on every Intel PCI-X chipset I ever saw too...

 - R.
