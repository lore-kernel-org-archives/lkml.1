Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZEIQlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZEIQlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZEIQlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:41:07 -0400
Received: from a2s31.a2hosting.com ([69.39.67.40]:47860 "EHLO
	a2s31.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZEIQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:41:06 -0400
MIME-Version: 1.0
Date: Sat, 09 May 2009 12:41:05 -0400
From: <v.virvilis@biovista.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: SATA disks resets in a md setup
In-Reply-To: <4A053229.5010406@garzik.org>
References: <200905081739.46206.v.virvilis@biovista.com> <4A053229.5010406@garzik.org>
Message-ID: <3794dbcf42f7f6b00e50070eeb203e8b@biovista.com>
User-Agent: RoundCube Webmail/0.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s31.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - biovista.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 May 2009 03:35:05 -0400, Jeff Garzik <jeff@garzik.org> wrote:

> 
> For hardware details, see 
> http://ata.wiki.kernel.org/index.php/Libata_error_messages

Thanks for the link.
> 
> The ATA bus is the cable connection, so an ATA bus error typically means
> 
> - problem with your cable, or
> - your motherboard's SATA port, or
> - your drive's SATA port, or
> - "dirty power" supply, or
> - some other cause for cable interference
> 

I have changed SATA cables twice and I added a better PSU. The problem
persists.

Do you have any insight on the sectors count mismatch I mentioned in the
first mail?
The disk is 250GB but it looks it is searching for a 500GB disk (that is
md0 = sda + sdb).

Is it possible the SATA reset thing to trigger an md bug. I am totally
guessing here...

Regards
            .bill

