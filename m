Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbXEIQEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbXEIQEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXEIQEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:04:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:27991 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbXEIQE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tp/9d3Pp0momCZwgqUTn6yk3VX/EynZNKAp+8ZksETpjVqrd6e9LZBtdCPW3HskYAsy9hMRSix4H32EgdwYoYNkdFEIIWoakcOx5DYoHI5FLXvf7PiPRbfjYPKMFMlqzWNieedwhexWuQhxfxy5RoWupCB2c8FkOXYiXy4NyniY=
Message-ID: <4641F100.70302@gmail.com>
Date: Wed, 09 May 2007 18:04:16 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Greg K-H <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       =?ISO-8859-1?Q?Mat=ED=ADas_Alejandro_Torres?= <torresmat@gmail.com>
Subject: Re: [PATCH] pci-quirks: disable MSI on RS400-200 and RS480, take
 #2
References: <4641BD26.1020501@gmail.com> <4641EAA5.4030409@redhat.com> <4641EDDC.1020102@gmail.com> <4641EF46.2090506@redhat.com>
In-Reply-To: <4641EF46.2090506@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Right, driver on such devices shouldn't enable MSI.  I think we have
several of those in ATA too.  Oh.. crap.  :-(

-- 
tejun
