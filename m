Return-Path: <linux-kernel-owner+w=401wt.eu-S1764827AbYHEVVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764827AbYHEVVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758665AbYHEVVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:21:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:48813 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512AbYHEVVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=j5EHLszQEIGsJeaO9dRYHcMJ9tXyJZdEXxZWm35UszTFVVfmLT94nqy6ac5HFNLOSn
         1tPlzVRIEmuPISvfmhgmPaFJorGHyiP0IAmK5OSBYxbc2Qf44sB4zLxgAlr4RdtrxKMm
         hYNzfgODawF1xy5s2IXGM3HPrl82ICabBIpp0=
Message-ID: <4898C44E.7020303@gmail.com>
Date: Tue, 05 Aug 2008 23:21:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ira Snyder <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Simple UART driver help and TTY questions
References: <20080805163307.GJ6257@ovro.caltech.edu>
In-Reply-To: <20080805163307.GJ6257@ovro.caltech.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2008 06:33 PM, Ira Snyder wrote:
> Hello LKML,
> So, the problem I have is that when I install this driver, it seems to
> return -EIO before it even hits any of the driver code. I checked this
> by putting a printk at the beginning of every function call in the
> module.
> 
> The error from busybox microcom is this:
> microcom: can't tcsetattr for /dev/ttytiny0: Input/output error
> 
> And cat /dev/ttytiny0:
> cat: /dev/ttytiny0: Input/output error
> 
> Previously to finding this code from LinuxJournal, I had tried to write
> my own skeleton driver, basing it on the drivers/serial/ucc_uart.c code.
> It has the exact same problem. I've attached it as well.
> 
> So, to the best of my research, it seems like the tcsetattr call would
> come in at drivers/char/tty_ioctl.c in tty_mode_ioctl() (the TCSETS
> case). Maybe I'm wrong, though.
> 
> I've built it against both ubuntu's stock kernel (2.6.24 based) and a
> recent pull of the kernel.org kernel.
> 
> I'd really appreciate help figuring out what this problem is.

Attach straces of your tries.
