Return-Path: <linux-kernel-owner+w=401wt.eu-S965084AbXCSDjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084AbXCSDjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 23:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXCSDjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 23:39:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:5014 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965084AbXCSDjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 23:39:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,298,1170662400"; 
   d="scan'208"; a="211799731:sNHT23379965"
Message-ID: <45FE05FE.80009@intel.com>
Date: Sun, 18 Mar 2007 20:39:42 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Greg.Chandler@wellsfargo.com
CC: auke-jan.h.kok@intel.com, hancockr@shaw.ca, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Subject: Re: 1000xf bus problem
References: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no> <45FD95CD.2030403@shaw.ca> <45FDA668.1090202@intel.com> <E8C008223DD5F64485DFBDF6D4B7F71D0289EDC1@msgswbmnmsp25.wellsfargo.com>
In-Reply-To: <E8C008223DD5F64485DFBDF6D4B7F71D0289EDC1@msgswbmnmsp25.wellsfargo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg.Chandler@wellsfargo.com wrote:
> If you mean dmesg it says this:
> e1000: 0000:0d:02.0: e1000_probe: (PCI-X:100MHz:64-bit)  {macaddress}
> 
> That's weird... dmesg shows one thing, lspci shows another, and my data
> transfers seem to point to the lspci info...
> 
> Any idea which I should trust?


Both, the e1000 driver asks the card what it sees from it's side of the 
connection, and lspci tells you what the cpu side of it is connected to.

Since stuff like pci bridges exist, both could very well be correct!

I highly suspect that that is exactly the case.


Auke
