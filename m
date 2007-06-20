Return-Path: <linux-kernel-owner+w=401wt.eu-S1762425AbXFTFXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762425AbXFTFXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 01:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbXFTFXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 01:23:45 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:57176 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbXFTFXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 01:23:44 -0400
Date: Wed, 20 Jun 2007 14:22:23 +0900
From: Mattia Dongili <malattia@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Message-ID: <20070620052222.GA4452@inferi.kami.home>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc4-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/

Hello,
on this vaio sz72b I can't suspend if usb-storage is loaded. Bisecting
is becoming troublesome as different sets have slightly different
problems.
At one point (with the GREGKH usb stuff built) I had the kernel
reporting it cannot stop the usb-storage thread so I guess that
something later in the series made things worse (freezable workqueues?).

Clues?
-- 
mattia
:wq!
