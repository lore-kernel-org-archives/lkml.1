Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbXLNScu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbXLNScu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbXLNScn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:32:43 -0500
Received: from host.infinivid.com ([64.119.179.76]:47792 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbXLNScn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:32:43 -0500
Subject: Re: PCI resource unavailable on mips
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
In-Reply-To: <20071214093945.GA25186@linux-mips.org>
References: <1197557806.3370.7.camel@microwave.infinitevideocorporation.com>
	 <20071214093945.GA25186@linux-mips.org>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 13:32:40 -0500
Message-Id: <1197657160.3420.11.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Odd.  I knew the resource allocation stuff has it's issues for some
> non-trivial configuration but that one is a new one.  Which makes me
> wonder if your platform runs the PCI code in probe-only mode where it
> will not actually assign resources but only inherit the whole PCI setup
> except interrupt routing from the firmware.
> 
> What MIPS platform do you use?  I'd like to take a look at its PCI setup
> code.
> 

I am using the MDS 810 STB as provided by MDS
(http://www.mds.com/products/product.asp?prod=MDS-810). The kernel and
entire environment (except my driver) was set up by MDS. uname output is
as follows.

 # uname -a
Linux 10.41.13.87 2.6.19PNX8550 #1 Wed Nov 21 14:55:52 EST 2007 mips
unknown

If I can provide additional information for you I'd be happy to help.

Thanks,
Jon

