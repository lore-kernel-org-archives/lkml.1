Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbXEIPvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbXEIPvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbXEIPvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:51:06 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:16323 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbXEIPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IMc58o5V+ED/dsFZATZZIkfknez50d8xzBM4grQQTYz/QcGk5FbhyWpRhqdszvSpWXko0pa+lghj71JtpykeuxANixKrveOOSpAJ+4ItQ6pEtLnkN5C/MF3sJh/em4kFjIPWs4Lp7mA7f2A5mRg6h4tnlrb0AsxmX2eV7aS1T0I=
Message-ID: <4641EDDC.1020102@gmail.com>
Date: Wed, 09 May 2007 17:50:52 +0200
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
References: <4641BD26.1020501@gmail.com> <4641EAA5.4030409@redhat.com>
In-Reply-To: <4641EAA5.4030409@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Tejun Heo wrote:
>> MSI doesn't work on RS400-200 and RS480 requiring pci=nomsi kernel
>> boot parameter for ahci to work.  This patch renames quirk_svw_msi()
>> to quirk_disable_all_msi() and use it to disable MSI on those chips.
>>
>>   http://thread.gmane.org/gmane.linux.ide/17820
>>   http://thread.gmane.org/gmane.linux.ide/17516
>>   https://bugzilla.novell.com/show_bug.cgi?id=263893
>>
> 
> FWIW several distros have turned off MSI by default and added
> a "pci=msi" option to enable it.

Yeah, it seem to cause a lot of problems on certain chips but I think
the correct path is to add PCI quirks for those.  Most MSI problems I've
seen are on these ATI chips.  Do you happen to know any other?

Thanks.

-- 
tejun
