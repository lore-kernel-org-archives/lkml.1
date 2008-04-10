Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYDJOxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYDJOxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbYDJOw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:52:56 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:41650 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756460AbYDJOw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:52:56 -0400
Date: Thu, 10 Apr 2008 10:52:55 -0400
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
Message-ID: <20080410145255.GC2160@csclub.uwaterloo.ca>
References: <20080409212840.GB2160@csclub.uwaterloo.ca> <E1JjiaS-0005QV-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JjiaS-0005QV-00@calista.eckenfels.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 12:16:12AM +0200, Bernd Eckenfels wrote:
> Unfortunatelly there is also bios' view of the geometry, which is especially
> a problem for boot loaders. Just another hint:
> 
> # lilo -T geom
> 
>     bios=0x00, cylinders=80, heads=2, sectors=18
>         (  1.44Mb         2,880 sectors)        C:H:S supported (PC bios)
> 
> BIOS reports 2 hard drives
>     bios=0x80, cylinders=527, heads=255, sectors=63     vol-ID: 2C731DD1
>         (  4.33Gb     8,467,199 sectors)        LBA32 supported (EDD bios)
>     bios=0x81, cylinders=527, heads=255, sectors=63
>         (  4.33Gb     8,467,199 sectors)        LBA32 supported (EDD bios)
> 
> (um yes my system is somewhat outdated, thats an adaptec scsi bios.

Just use LBA.  Both lilo and grub can, in which case they no longer care
about the geometry at all.

-- 
Len Sorensen
