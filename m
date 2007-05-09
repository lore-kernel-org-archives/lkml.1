Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbXEIP5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbXEIP5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXEIP5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:57:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106AbXEIP5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:57:01 -0400
Message-ID: <4641EF46.2090506@redhat.com>
Date: Wed, 09 May 2007 11:56:54 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Greg K-H <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       =?ISO-8859-1?Q?Mat=ED=ADas_Alejandro_Torres?= <torresmat@gmail.com>
Subject: Re: [PATCH] pci-quirks: disable MSI on RS400-200 and RS480, take
 #2
References: <4641BD26.1020501@gmail.com> <4641EAA5.4030409@redhat.com> <4641EDDC.1020102@gmail.com>
In-Reply-To: <4641EDDC.1020102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> FWIW several distros have turned off MSI by default and added
>> a "pci=msi" option to enable it.
> 
> Yeah, it seem to cause a lot of problems on certain chips but I think
> the correct path is to add PCI quirks for those.  Most MSI problems I've
> seen are on these ATI chips.  Do you happen to know any other?

We had devices that didn't do MSI right, e.g. forcedeth and others I
can't recall now.
