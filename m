Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYDCRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYDCRrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYDCRrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:47:11 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:50769 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655AbYDCRrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:47:10 -0400
From: Frans Pop <elendil@planet.nl>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Thu, 3 Apr 2008 19:47:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200804021524.27222.elendil@planet.nl> <200804021820.04610.elendil@planet.nl> <20080402194938.GI24237@csclub.uwaterloo.ca>
In-Reply-To: <20080402194938.GI24237@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031947.07674.elendil@planet.nl>
X-OriginalArrivalTime: 03 Apr 2008 17:47:08.0407 (UTC) FILETIME=[BCC91070:01C895B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Lennart Sorensen wrote:
> > Yes, that could be one way to implement it: load it and then check if
> > that added any devices.
>
> Well even if you see other disks doesn't mean you don't also have an old
> IDE controller you want to use, so probably load it and see if it finds
> any disks is the best bet after loading all the other probeable drivers
> first.

I've decided (at least for now) to only do this f /sys/bus/isa is present.
I added a check to see if there are additional devices in /sys/block after 
loading ide-generic to decide whether or not to also include it in the 
initrd for the installed system.

/sys/bus/isa is present for this machine so it works even if (as Ondrej 
suggests) the controller is not actually on the ISA bus. We can always 
extend the test if it turns out systems without ISA bus are also affected.

I'll also send out a call for testing specifically for this issue.

Thanks to you and Ondrej for the discussion.

Cheers,
FJP
