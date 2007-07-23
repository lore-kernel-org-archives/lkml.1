Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXGWLOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXGWLOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759748AbXGWLOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:14:03 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:50839 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589AbXGWLOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:14:02 -0400
Message-ID: <46A48D12.4070204@gmail.com>
Date: Mon, 23 Jul 2007 13:12:18 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: BuraphaLinux Server <buraphalinuxserver@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SCSI vs SATA
References: <5d75f4610707230352j69b2ba53g1564e420fc64ea49@mail.gmail.com>
In-Reply-To: <5d75f4610707230352j69b2ba53g1564e420fc64ea49@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2007 12:52 PM, BuraphaLinux Server wrote:

> #!  /bin/bash
> drive="sda"
> vendor=$(</sys/block/${drive}/device/vendor)
> if [[ "${vendor}" = "ATA     " ]]
> then
>  printf "SATA\n"
> else
>  printf "SCSI\n"
> fi
> exit 0

This is probably not a useful comment and a reasonable script in your local 
setting but still thought I'd point out that these days most anything is 
sda, so if !SATA it can generally also be USB, or FW, or ...

Rene.

