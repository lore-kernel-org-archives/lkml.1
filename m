Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYDCTbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYDCTbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYDCTbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:31:35 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50952 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421AbYDCTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:31:34 -0400
Date: Thu, 3 Apr 2008 15:31:22 -0400
To: Frans Pop <elendil@planet.nl>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080403193122.GQ24237@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl> <200804021820.04610.elendil@planet.nl> <20080402194938.GI24237@csclub.uwaterloo.ca> <200804031947.07674.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804031947.07674.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 07:47:06PM +0200, Frans Pop wrote:
> I've decided (at least for now) to only do this f /sys/bus/isa is present.
> I added a check to see if there are additional devices in /sys/block after 
> loading ide-generic to decide whether or not to also include it in the 
> initrd for the installed system.

I am just wondering if arm, m68k, etc might have IDE ports that work
with ide-generic.  I have no idea to be quite honest.

> /sys/bus/isa is present for this machine so it works even if (as Ondrej 
> suggests) the controller is not actually on the ISA bus. We can always 
> extend the test if it turns out systems without ISA bus are also affected.

Hmm, I must admit my newest x86 does in fact not have a /sys/bus/isa.  I
guess it really does not have anything left resembling ISA.

> I'll also send out a call for testing specifically for this issue.

I can certainly give the installer a shot on my 486, if I can manage to
boot it somehow.  Any floppy images for the installer around anymore? :)

Do I have to put a disk image on a harddisk and boot from that?  CD and
network boot are not an option.

-- 
Len Sorensen
