Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbXEITYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbXEITYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXEITYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:24:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46573 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXEITYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:24:00 -0400
Message-ID: <46421FCA.7010807@garzik.org>
Date: Wed, 09 May 2007 15:23:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Tejun Heo <htejun@gmail.com>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       =?ISO-8859-1?Q?Mat=ED=ADas_Alejandro_Torres?= <torresmat@gmail.com>
Subject: Re: [PATCH] pci-quirks: disable MSI on RS400-200 and RS480, take
 #2
References: <4641BD26.1020501@gmail.com> <4641EAA5.4030409@redhat.com> <4641EDDC.1020102@gmail.com> <4641EF46.2090506@redhat.com>
In-Reply-To: <4641EF46.2090506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Tejun Heo wrote:
>>> FWIW several distros have turned off MSI by default and added
>>> a "pci=msi" option to enable it.
>> Yeah, it seem to cause a lot of problems on certain chips but I think
>> the correct path is to add PCI quirks for those.  Most MSI problems I've
>> seen are on these ATI chips.  Do you happen to know any other?
> 
> We had devices that didn't do MSI right, e.g. forcedeth and others I
> can't recall now.

AFAIK that's a broken diagnosis.   It's the system, not the device, that 
is problematic.

	Jeff



