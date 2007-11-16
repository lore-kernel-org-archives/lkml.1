Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbXKPTjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbXKPTjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXKPTjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:39:42 -0500
Received: from lazybastard.de ([212.112.238.170]:54091 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbXKPTjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:39:41 -0500
Date: Fri, 16 Nov 2007 20:34:32 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lee Revell <rlrevell@joe-job.com>,
       Stefan Monnier <monnier@iro.umontreal.ca>, linux-kernel@vger.kernel.org
Subject: Re: Treat disk space like memory space
Message-ID: <20071116193432.GD17372@lazybastard.org>
References: <jwvr6irqhn2.fsf-monnier+gmane.linux.kernel@gnu.org> <75b66ecd0711151624n476d2e83xd1acbb23a5bffcf0@mail.gmail.com> <473DE1B4.8090703@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <473DE1B4.8090703@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 November 2007 10:30:12 -0800, H. Peter Anvin wrote:
> 
> This, by the way, has been discussed on and off -- often in the context 
> of undelete (which is an identical problem.)  The problem usually is 
> that performance of real storage users suffer because of locality 
> issues.  However, flash storage doesn't have locality requirements...

It does, although significantly less so than disks.  Read latency is
typically between 100x and 1000x less than disk latency.

Another argument against this is that free space directly translates to
speed, both for disks and flash.  Disk filesystems fragment like hell if
the disk is constanly near-full and flash filesystems require a lot more
garbage collection overhead.

Jörn

-- 
To my face you have the audacity to advise me to become a thief - the worst
kind of thief that is conceivable, a thief of spiritual things, a thief of
ideas! It is insufferable, intolerable!
-- M. Binet in Scarabouche
