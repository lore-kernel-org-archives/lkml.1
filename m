Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYFCORq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYFCORq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 10:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYFCORi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 10:17:38 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:42014 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYFCORi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 10:17:38 -0400
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 10:17:37 EDT
Message-ID: <48454EFC.9080201@pobox.com>
Date: Tue, 03 Jun 2008 10:02:36 -0400
From: Mark Lord <mlord@pobox.com>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Who can backport the AHCI driver to older kernels
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com>
In-Reply-To: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: BD260E74-3175-11DD-BEBB-B8BFEAD4C077-82205200!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rainer Koenig wrote:
> Hi,
>  
> I need help and/or advice on the following problem:
> 
> New mainboard platfrom with latest chipset from a chipset vendor that 
> can't do the job that we are asking for. The chipset (especially the
> SATA controller is supported in Kernel 2.6.24 and later. 
> 
> The target market for those boards is using old fashioned distributions 
> like CentOS, Debian, Fedora 8 openSUSE 10 and so on. So the gap is that 
> the latest driver from 2.6.24 is not yet in those distributions. The 
> impact of this is that the customer in the target market can't use the
> mainboards to run actual Linux distributions on them.
> 
> So there is a need ot backport e.g. the AHCI driver from 2.6.24 to 
> 2.6.16 or 2.6.18. Doing a diff on the sources makes me think this is a 
> sort of "mission impossible" since it sureley isn't just the ahci code
> that changed but also a lot in the kernel infrastructure meanwhile.
> 
> So what options do we have to help the customer? Changing to 2.6.24 
> kernel is not an option due to the customer. So it looks like the 
> only way to "solve" this is a backport, but then we come to "who can
> do this?". 
..

I regularly do backports of libata stuff for various clients.
Contact me directly if you feel you really need this service.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
