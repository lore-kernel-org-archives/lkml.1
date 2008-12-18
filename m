Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752806AbYLRTL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYLRTL7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYLRTLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:11:44 -0500
Received: from poll.devit.com ([216.165.189.132]:59753 "EHLO mx0.devit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751380AbYLRTLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:11:43 -0500
X-Greylist: delayed 1690 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Dec 2008 14:11:43 EST
Message-ID: <494A99EF.6070400@flurg.com>
Date: Thu, 18 Dec 2008 12:43:59 -0600
From: "David M. Lloyd" <dmlloyd@flurg.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        scst-devel@lists.sourceforge.net,
        Bart Van Assche <bart.vanassche@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC]: Support for zero-copy TCP transmit of user space data
References: <494009D7.4020602@vlnb.net> <494012C4.7090304@vlnb.net> <20081210214500.GA24212@ioremap.net> <4941590F.3070705@vlnb.net> <1229022734.3266.67.camel@localhost.localdomain> <4942BAB8.4050007@vlnb.net> <1229110673.3262.94.camel@localhost.localdomain> <49469ADB.6010709@vlnb.net> <20081215231801.GA27168@infradead.org> <4947FA1C.2090509@vlnb.net> <494A97DD.7080503@vlnb.net>
In-Reply-To: <494A97DD.7080503@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2008 12:35 PM, Vladislav Bolkhovitin wrote:
> An iSCSI target driver iSCSI-SCST was a part of the patchset 
> (http://lkml.org/lkml/2008/12/10/293). For it a nice optimization to 
> have TCP zero-copy transmit of user space data was implemented. Patch, 
> implementing this optimization was also sent in the patchset, see 
> http://lkml.org/lkml/2008/12/10/296.

I'm probably ignorant of about 90% of the context here, but isn't this the 
sort of problem that was supposed to have been solved by vmsplice(2)?

- DML

