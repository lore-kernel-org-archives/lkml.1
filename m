Return-Path: <linux-kernel-owner+w=401wt.eu-S933192AbXHVQ7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbXHVQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762137AbXHVQ7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:59:06 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:59973 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760634AbXHVQ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:59:02 -0400
Message-ID: <46CC6A2F.5000406@gmail.com>
Date: Wed, 22 Aug 2007 18:54:07 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jos? Luis Pati?o Andr?s <jopan@alumni.uv.es>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: Problems with IDE on linux 2.6.22.X
References: <200708212149.12912.jopan@alumni.uv.es> <46CB626F.8020801@gmail.com> <200708220339.45138.jopan@alumni.uv.es> <46CBA0F0.70503@gmail.com> <20070822122359.7ce8ddaa@the-village.bc.nu> <46CC5AE4.1090600@gmail.com> <20070822162312.GG9412@csclub.uwaterloo.ca>
In-Reply-To: <20070822162312.GG9412@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2007 06:23 PM, Lennart Sorensen wrote:

> On Wed, Aug 22, 2007 at 05:48:52PM +0200, Rene Herman wrote:

>> He has a SATA harddrive and an IDE DVD drive. When he compiles with 
>> CONFIG_ATA_PIIX (a driver which advertises both SATA and PATA in its 
>> description) his drive works, his DVD does not. Is that not the correct 
>> driver? Does he need something else? How does he get his DVD to work?
> 
> Well of course the DVD should show up as /dev/sr0 or scd0 with the new
> driver, not the /dev/hd? name.  And scsi cdrom support is required too.

Obviously. Looking back through the report, him having SCSI CD-ROM support 
wasn't actually explicit so that might in fact be the problem but his 
self-compiled 2.6.20.15 worked and a 2.6.22 based Open SuSE Live CD does not 
(and he does have SCSI disk support, which suggests he will've likely also 
have thought of SCSI CD-ROM support) so it does not seem to be.

José: do you have SCSI CD-ROM support compiled in? What are the ATA/SCSI 
related messages in the output of "dmesg" when you compile with the 
CONFIG_ATA_PIIX driver, SCSI disk and SCSI CD-ROM support (and nothing from 
the old IDE menu)?

Rene.

