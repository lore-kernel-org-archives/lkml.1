Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbXLKSx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbXLKSx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXLKSxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:53:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33302 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXLKSxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:53:18 -0500
Date: Tue, 11 Dec 2007 19:53:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Anas Nashif <nashif@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20071211185317.GA21864@one.firstfloor.org>
References: <475EC9C1.9080708@linux.intel.com> <p7363z5nlo8.fsf@bingen.suse.de> <475ED912.609@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475ED912.609@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 01:38:10PM -0500, Anas Nashif wrote:
> There are different ways you can connect to the Firmware and it all depends on
> the ME subsystem you want to communicate with.
> For Intel AMT, you would use LMS (Local Manageability Service) which acts as a
> proxy for SOAP messages coming for management applications. LMS is available via
> http://openamt.org/wiki/LocalManageabilityService.
> 
> The demo we had for storing kernel oops messages in the firmware used the AMT
> 1.0 interface (legacy) which allowed direct access to 3PDS using the MEI driver
> interfaces. In AMT 3.0 (current platforms) this has been disabled and only SOAP
> is possible which is why in the demo we changed the ME firmware to use AMT 1.0.

Ok but saving oops is such a useful facility that we'll probably need 
to think about implementing SOAP in the kernel. Before everybody complains
that I went crazy: I suspect with some simplifying assumptions it could
be made relatively straight forward code. In particular if one assumes
no packets get lost then it would be possible to strip down TCP greatly
(so it doesn't need to be much more complicated than netconsole) 
and I suspect a very minimal SOAP parser just for this application would
be also possible.

> To have a feel for all of this, with many examples, samples and documentation
> you can download the AMT 3.0 SDK (google: intel amt sdk).

I would be more interested right now how the kernel can use this without
additional user space support. Any ideas on this? 

-Andi

