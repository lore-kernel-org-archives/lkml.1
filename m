Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZASSCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZASSCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZASSBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:01:54 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:58449 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208AbZASSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:01:54 -0500
Message-ID: <4974C030.5020509@ru.mvista.com>
Date: Mon, 19 Jan 2009 21:02:24 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>	<20090119130322.24745.76137.sendpatchset@localhost.localdomain>	<49748B95.9080105@ru.mvista.com>	<200901191523.15240.bzolnier@gmail.com>	<49748E43.4030009@ru.mvista.com> <20090119173701.13fd24c6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090119173701.13fd24c6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>>>[ I'm also not happy with the naming but couldn't think of a better one. ]

>>    Legacy perhaps?

> Legacy to most people means either ISA/VLB or the PCI legacy
> compatibility mode so that would be confusing.

    That's what this code is for (minus the MMIO accessors perhaps).

> BTW if you moved to ioreadX you could get rid of almost all the readb/inb
> special casing.

    And burden the driver code with function calls ISO in/out instructions, at 
least on x86. It's somewhat arguable move.

MBR, Sergei
