Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZGEI2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZGEI2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 04:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZGEI2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 04:28:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:35249 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZGEI2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 04:28:39 -0400
Date: Sun, 5 Jul 2009 01:30:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Core i7 not scaling frequency down
Message-ID: <20090705013001.6e0c17bf@infradead.org>
In-Reply-To: <20090704203732.GA20170@codeblau.de>
References: <20090704203732.GA20170@codeblau.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jul 2009 22:37:32 +0200
Felix von Leitner <felix-linuxkernel@fefe.de> wrote:

> Hi,
> 
> I just got a Nehalem CPU and it works OK except that the fans are
> always running full power and it produces heat like an oven.
> 
>   $ cat /proc/acpi/processor/P001/info
>   processor id:            0
>   acpi id:                 1
>   bus mastering control:   yes
>   power management:        yes
>   throttling control:      no
>   limit interface:         no
>   $
> 
> Oh, no throttling and no limit support?  How can this be?  I'm using
> 2.6.30 but this appears to be bogus; Windows scales down the CPU
> frequency OK.

how do you determine linux isn't scaling down? PowerTOP?
(if not powertop.. you might want to use that ;-)

>   ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] -
> 00, should be FE [20090320]

that's pretty bad, but might not be a table critical for C/P states...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
