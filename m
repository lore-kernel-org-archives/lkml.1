Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYBYUD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYBYUD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYBYUDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:03:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYBYUDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:03:47 -0500
Message-ID: <47C31F05.2070307@redhat.com>
Date: Mon, 25 Feb 2008 15:03:17 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
References: <19f34abd0802230948n3b98b7d2kd67ca9c2f8fbbd47@mail.gmail.com>
In-Reply-To: <19f34abd0802230948n3b98b7d2kd67ca9c2f8fbbd47@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2008 12:48 PM, Vegard Nossum wrote:
> 
> I don't see the connection between (no-)smp and ata. Something with
> interrupt routing/IPI, missing irq ack? Booting another !SMP kernel
> works fine. The problem also exists in 2.6.24-rc2.
> 

"nosmp" disables the IO-APIC which will change interrupt handling.

If you just want to enable a single CPU, use "maxcpus=1".
