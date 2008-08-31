Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYHaSPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYHaSPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 14:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbYHaSPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 14:15:04 -0400
Received: from prod-mail-xrelay04.akamai.com ([72.246.198.135]:51856 "EHLO
	prod-mail-xrelay04.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579AbYHaSPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 14:15:03 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Aug 2008 14:15:03 EDT
Date: Sun, 31 Aug 2008 11:07:31 -0700
From: Jason Uhlenkott <juhlenko@akamai.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Douglas Thompson <dougthompson@xmission.com>,
       Tim Small <tim@buttersideup.com>, Greg KH <greg@kroah.com>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] remove the broken i82443bxgx_edac driver
Message-ID: <20080831180731.GA19695@juhlenko-desk.sanmateo.corp.akamai.com>
References: <20080831161011.GD3695@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080831161011.GD3695@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 19:10:11 +0300, Adrian Bunk wrote:
> The i82443bxgx_edac driver was added more than one year ago, but after 
> only 3 seconds in Linus' tree it got a dependency on BROKEN with Andrew 
> stating:
> 
>     It will claim the PCI devices from under intel_agp.ko's feet.
>     Greg is brewing some fix for that.
> 
> Since noone seems to care enough about this driver to get it working we 
> can as well remove it.

This driver does work as long as it's not used concurrently with
intel-agp, and I know of at least one user of it (who has been locally
diking out the dependency on BROKEN).
