Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYCVITG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYCVITG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 04:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYCVISu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 04:18:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:23987 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbYCVISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 04:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UVY2XNPYIbqF/ypui6V/qv7M2QuLOO408SO5GjofInJaOpDcPUPKLn6+Z07lD9hiVvyWV7AsX1c3Wdrtnz1qTpYBevyXUmXbiw9+k3QHd889QpmDX1Tg+DlBLBRvkkEHBh4md9tyTbpr00Ji6wfvVaxNgp2aq3PtJItIDifFVKU=
Message-ID: <47E4C0E0.4080307@gmail.com>
Date: Sat, 22 Mar 2008 17:18:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: osb972ww-linuxczmil@yahoo.com
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Fw: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <810485.52126.qm@web34507.mail.mud.yahoo.com>
In-Reply-To: <810485.52126.qm@web34507.mail.mud.yahoo.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

osb972ww-linuxczmil@yahoo.com wrote:
> Tejun, Alan,
> 
> Everything works when I disable the USB in the bios settings.  I was
> also able to remove the irqpoll kernel parameter after turning off
> bios USB. The particularly interesting thing is that the USB mouse
> still works, as does a USB 2.0 drive I have connected.  The Compact
> Flash drive at /dev/sda works fine, and the connected SATA drive
> works as well, though I need to do some testing to see how well these
> devices are performing.

Hmmm.. Can you please file a bug report against USB subsystem on
bugzilla.kernel.org and cc me?  USB on your system is triggering IRQ storm.

> Using the irqpoll also made things work except for once.  In that
> case, I got the same errors, delayed bootup, and missing SATA drive.

Hmmm.. Do you have logs?

> Is there a new "hdparm like" tool for working with the new
> drives/drivers to be able to read/set parameters, run various tests,
> etc?

hdparm will still be the utility of choice but libata doesn't allow many
settings IDE used to and libata probably will never implement some of
IDE's tunables.  Is there any specific setting you have in mind?

Thanks.

-- 
tejun
