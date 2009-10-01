Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZJAV4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZJAV4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZJAV43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:56:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:11454 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZJAV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:56:28 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 17:56:28 EDT
X-IronPort-AV: E=Sophos;i="4.44,489,1249272000"; 
   d="scan'208";a="67224538"
Message-ID: <4AC5234C.5030409@citrix.com>
Date: Thu, 01 Oct 2009 14:46:52 -0700
From: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: "ketuzsezr@darnok.org" <ketuzsezr@darnok.org>,
       "pjones@redhat.com" <pjones@redhat.com>,
       Martin Wilck <Martin.Wilck@fujitsu-siemens.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iSCSI/iBFT: use proper address translation
References: <4AC47DED0200007800017743@vpn.id2.novell.com>
In-Reply-To: <4AC47DED0200007800017743@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2009 21:46:56.0003 (UTC) FILETIME=[B2017D30:01CA42E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/09 01:01, Jan Beulich wrote:
> In virtual environments (namely, Xen Dom0) virt <-> phys and
> virt <-> isa-bus translations cannot be freely interchanged. When
> looking at memory below 1M, the latter translations should always
> be used.
>   

Do you have a different definition for isa_virt_to_bus in your kernel? 
As far as I can see it is defined to be the same as virt_to_phys.  Also,
the ISA memory is identity mapped into the domain's physical mapping
space, so it should be directly accessible without any problems.

    J
