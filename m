Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYCUCYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYCUCYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 22:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYCUCX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 22:23:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:36473 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYCUCX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 22:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IHrWRViSSDM7VENs0okuUrGQM2FhmQ+1wk9mJD7kQROlJwtcV6EI1hhpbSFg8bSyETUL5fAf3Jli7h54qXvZ0e3CggCmXa92x58JBH3KLmniw0VNFQoHLFIhx+3mSmX/IEDLZX/k4vzs0WXwgJ43tRnb+LvNNJ/sBVlH8+IKC8Q=
Message-ID: <47E31C36.6060903@gmail.com>
Date: Fri, 21 Mar 2008 11:23:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: osb972ww-linuxczmil@yahoo.com
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Fw: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <343296.8242.qm@web34508.mail.mud.yahoo.com>
In-Reply-To: <343296.8242.qm@web34508.mail.mud.yahoo.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

osb972ww-linuxczmil@yahoo.com wrote:
>  Greetings,
>   I'm having a problem with 2.6.23.1-42 (Fedora 8) properly driving a SATA 
> drive.  Although it is detected during boot as indicated by the dmesg below, 
> once the sytstem is up and running, the drive is not accessible.   The second 
> issue is with the CFdrive on the the primary IDE.  It works, but I can't enable 
> interrupts with hdparm -u 1 /dev/sda.   
> 
>  The interesting thing is when I put in a Fedora 5 system with a 2.6.17 kernel, 
> everything works as expected.  I can hdparm -u 1 /dev/hda and it works as  expected, and
>  the SATA drive is detected and works properly all on the exact  same hardware.  
>  
>  I've tried several different SATA drives also.   Thery all work on the old 
>  Fedora 5/ 2.6.17 system, and none work on Fedora 8/2.6.23 or 2.6.24 kernels.

Does irqpoll kernel parameter help?

-- 
tejun
