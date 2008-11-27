Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYK0AGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYK0AGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYK0AFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:05:48 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:51896 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752906AbYK0AFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:05:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=pU9LiUvcOWyAKIrEVZIO7DiOpSzh2qu+5eeuLmylZdhcQXq0mkz6RhJYBbzdEZdedPJuu+M4i2z8BVRbmt8uP41DmiQ++ZJhZLglCoJZeW/LEj0ge+ao+SM3uoDcjRVy;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: oops/warning report for the week of November 26, 2008
Date: Wed, 26 Nov 2008 16:05:37 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <492DD792.6080302@linux.intel.com>
In-Reply-To: <492DD792.6080302@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811261605.43099.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 26, 2008 3:11 pm Arjan van de Ven wrote:
> Rank 2: pci_create_slot (warning)
> 	Reported 603 times (639 total reports)
> 	BIOS provided duplicated slot names, the PCI layer blindly passes to sysfs
> 	This warning was last seen in version 2.6.27.5, and first seen in
> 2.6.27-rc7-git1. More info:
> http://www.kerneloops.org/searchweek.php?search=pci_create_slot

IIRC we fixed this one post-2.6.27.  I didn't send the patches back to -stable 
because they were a bit big, but if someone were sufficiently motiviated I'm 
sure the backport wouldn't be that hard...

Jesse
