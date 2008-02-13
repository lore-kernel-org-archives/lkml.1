Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYBMCrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYBMCrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYBMCrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:47:46 -0500
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:2069 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbYBMCrp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:47:45 -0500
Date: Wed, 13 Feb 2008 02:43:29 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Greg KH <greg@kroah.com>
Cc: bzolnier@gmail.com, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: "ide=reverse" do we still need this?
Message-ID: <20080213024329.GA6912@deepthought>
References: <20080213001506.GA13933@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080213001506.GA13933@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.0 c=1 a=gcwBkTFKDvoA:10 a=9vzMQgj8eMJxLs+ya4Hk2A==:17 a=D3wefQSD8yZxRaRuTKEA:9 a=UhGMt6uKUyvYFXl5IXAA:7 a=vZsx1vOZ1RPvF74ws1X0okK0VsAA:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:15:07PM -0800, Greg KH wrote:
> 
> I'm curious if we really still support the ide=reverse option?  It's a
> config option that I don't think the distros still enable (SuSE does
> not).  Is this still needed these days?
> 
 My "server" has a consumer-grade desktop amd64 mobo, with all that
implies about cheap hardware and strange/misleading bios options.
It also has an add-in dual IDE card with the main data on raid1.
It's set to ide=reverse, without that it doesn't boot (the add-ins
are IDE, system drive is SATA, so I guess it probably tries to boot
from the DVD - it's been a long time since it bit me and I don't
remember the full details.

 That was how it was set for 2.6.18.6, and how it now boots from
2.6.22.18.  I think at one time the order of the interfaces might
have been different.  Certainly, I carry forward a fallback without
ide=reverse in lilo.conf, just in case the disks move on my next
kernel upgrade.

 What a distro selects should cover most of that distro's users, but
that is not anywhere near providing 100% coverage for *all* the
hardware out there.  Also, you can force your users to e.g. mount by
label.  So far, that hasn't been forced on me, and I really hate
having to reboot that box :)

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
