Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYH2TKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYH2TKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYH2TJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:09:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbYH2TJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:09:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alistair John Strachan <alistair@devzero.co.uk>
Subject: Re: md (regression): reboot/shutdown hangs
Date: Fri, 29 Aug 2008 21:13:43 +0200
User-Agent: KMail/1.9.9
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <200808282005.09416.alistair@devzero.co.uk>
In-Reply-To: <200808282005.09416.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808292113.44268.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[More CCs]

On Thursday, 28 of August 2008, Alistair John Strachan wrote:
> Hi Neil,
> 
> Commit 2b25000bf5157c28d8591f03f0575248a8cbd900 ("Restore force switch of md 
> array to readonly at reboot time.") causes a reboot/shutdown to hang 
> indefinitely on my box. Reverting this single commit makes the problem go 
> away. It was first released with 2.6.27-rc3, I believe, and so this is a 
> regression vs 2.6.26 (Rafael CCed).
> 
> I think the problem might be because my rootfs is on a RAID5 and my distro 
> fails to stop it completely before halt/reboot.
> 
> Please let me know if there's any more information you need from me.
> 


