Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbXJXSGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbXJXSGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbXJXSGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:06:39 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:48859 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXJXSGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CL9mkKE3h17ELe/Yowqqxbw6zsMSCB+l8mRa34nlAam/qcb0mrVHc+ptJGLScLIz8BnW8OkTjWT2sZWuue+Bb5aVdbukFWQoR5ZpRbf2yQM36tjysKP7m8sLil2K5j+OabZwyLCEn5BKCdx69PtTyQPcUfGZYd4Fo8yvLrOa6R0=
Message-ID: <7b9198260710241106l1c24ef8cgbd56da60ba28122@mail.gmail.com>
Date: Wed, 24 Oct 2007 19:06:37 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Sky2 Driver Issue
In-Reply-To: <7b9198260710241058o49a5eb93sf4fa8c22cc037a0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b9198260710241058o49a5eb93sf4fa8c22cc037a0e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/2007, Tom Spink <tspink@gmail.com> wrote:
> Hi,
>
> A couple of kernels ago, I ran into an issue with the sky2 driver.
> Basically, I began getting repeated errors on my console of the
> following:
>
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0xc0000000
>
> Which eventually led to:
> Oct 21 16:33:49 holly kernel: printk: 92 messages suppressed.
>
> Here is a section of the log that may be useful:
> Oct 21 16:33:37 holly kernel: sky2 eth1: enabling interface
> Oct 21 16:33:38 holly dhclient: DHCPDISCOVER on eth1 to
> 255.255.255.255 port 67 interval 8
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000010
> Oct 21 16:33:39 holly kernel: sky2 eth1: Link is up at 1000 Mbps, full
> duplex, flow control both
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0xc0000000
> Oct 21 16:33:40 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
> Oct 21 16:33:40 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0xc0000000
> Oct 21 16:33:41 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
> Oct 21 16:33:41 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0xc0000000
> Oct 21 16:33:42 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
>
> These messages are appearing on all the VTs, and because they keep
> popping up, I can't reasonably use the consoles to test if the network
> driver is working.
>
> The kernel I've got going at the moment is 2.6.23-rc9 with git
> revision g804b3f9a, and it's fine.  The error surfaced _sometime_
> after this.  Attached is my .config.
>
> I'll try rebooting and pinging the machine to see if the network
> driver is working, and this is just (unnecessary?) spew from the
> kernel.
>
> --
> Regards,
> Tom Spink
> University of Edinburgh
>
>

Hi again,

So it seems the driver and the network card is functioning, but I'm
getting the 'error interrupt' message plastered over every console.

I can ping and ssh into the computer, but the message is still
scrolling everything off my screens.

-- 
Regards,
Tom Spink
University of Edinburgh
