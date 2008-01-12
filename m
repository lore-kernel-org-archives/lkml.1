Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbYALIZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbYALIZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 03:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbYALIZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 03:25:44 -0500
Received: from mx27.mail.ru ([194.67.23.23]:5036 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758543AbYALIZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 03:25:44 -0500
X-Greylist: delayed 153666 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jan 2008 03:25:43 EST
Message-ID: <47887982.6050805@mail.ru>
Date: Sat, 12 Jan 2008 10:25:38 +0200
From: Alexander <aledin@mail.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: PROBLEM REMAINS: [sata_nv ADMA breaks ATAPI] Crash on accessing
 DVD-RAM
References: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no> <478702C7.80401@shaw.ca>
In-Reply-To: <478702C7.80401@shaw.ca>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> There's this patch which was intended to fix it:
> 
> http://lkml.org/lkml/2007/11/22/148

I applied this patch to 2.6.24-rc7. Now at boot time my DVD-RW is
normaly detected as:

sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray

But I cannot mount it. All my attempts failed with

ISOFS: Unable to identify CD-ROM format.

With mem<=4098M or sata_nv.adma=0 it still mounts and works ok.

