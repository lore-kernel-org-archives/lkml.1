Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbYBMPdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbYBMPdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765681AbYBMPcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:32:55 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:16781 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765620AbYBMPcx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:32:53 -0500
X-Greylist: delayed 46160 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 10:32:52 EST
Date: Wed, 13 Feb 2008 15:32:49 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Greg KH <greg@kroah.com>
Cc: bzolnier@gmail.com, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: "ide=reverse" do we still need this?
Message-ID: <20080213153249.GA21749@deepthought>
References: <20080213001506.GA13933@kroah.com> <20080213024329.GA6912@deepthought> <20080213044304.GA10101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080213044304.GA10101@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.0 c=1 a=gcwBkTFKDvoA:10 a=9vzMQgj8eMJxLs+ya4Hk2A==:17 a=pNW6cQKn9FihKhajbjwA:9 a=Zqjk-1MapEMWYelw3PQA:7 a=tuQzrf_9KcnmJzNn_QOi9SDneBwA:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 08:43:04PM -0800, Greg KH wrote:
> 
> Can't you just boot with /dev/disk/by-id/ and an initramfs to not have
> to worry about such a thing in the future?
> 
 Can comebody remind me what the initramfs is for in that situation,
please ?  From the little I've noticed, I thought the /dev/disk/by-id
part went into fstab ?  At the moment, I just build the things I
think I need in to the kernel on that box, without modules.

 Anyway, I'll try to find time to read my notes to see if I can
identify what happened/when, and to take the box down again so I
can try to confirm exactly what the problem is, if it still exists.
I certainly won't be taking it down until I've written my weekly
backups to tape at the weekend, so maybe not before next week.

> Have you tried the PATA drivers instead of IDE to see if this solves the
> "moves around" issue?  If they work, then you would not need the command
> line option at all.

 My previous kernel was 2.18-series, I think at that time they were
still under development.  This box handles the backups for my
various desktop boxes, which is why I'm very conservative about
changing it.  I guess the drivers are stable now, I'll maybe give
that a go (depending on time).

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
