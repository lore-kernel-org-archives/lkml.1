Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbXHZXh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbXHZXh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 19:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbXHZXhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 19:37:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:26815 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbXHZXhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 19:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C3hHw5HmDh3d4nE5cuEysV77yKEZSXPkysP2tc+H4P3McDF02T+adhCAVKGkPO8GD5a3eV931C/jPmX+8/vaG9YsZDmUhdozj4V4g+hT/G4X8ahOWHygd22aGItUcwSaJXUaQZjBCNa+BA8EbMHaQx+gQsE1kGjQUwv/gY7YXfs=
Message-ID: <6bffcb0e0708261637s3369dd6fl1f833461e41c4daa@mail.gmail.com>
Date: Mon, 27 Aug 2007 01:37:14 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Paul Rolland" <rol@as2917.net>
Subject: Re: [2.6.22.5] irq X: nobody cared but X is successfully used by libata
Cc: linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <20070826203513.4fa35f68@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070826203513.4fa35f68@tux.DEF.witbe.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Adding linux-ide to CC]

On 26/08/07, Paul Rolland <rol@as2917.net> wrote:
> Hello,
>
> My machine (an ASUS P5W-DH-Deluxe, Core2, 4Go RAM, 3 SATA and 2IDE) is
> reporting a :
> irq 23: nobody cared (try booting with the "irqpoll" option)
> together with a Call Trace, but :
>  - irqpoll is present on the command line,
>  - the irq is reported to be used by libata,
>  - the irqpoll option is mandatory if I want _some_ of my SATA disks to be
>    accessible.
>
> I've attached a file with :
>  - dmesg,
>  - cat /proc/interrupts
>  - lspci
>  - lspci -vvv
>  - my .config
>
> I've tried mounting and accessing all the disks, and it works.
> The last weird thing : though reported as used by libata, the irq 23 counter
> seems to be fixed at 200001, though I've mounted and accessed all the
> disks !
>
> Paul
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
