Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbYDNNrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbYDNNrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYDNNrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:47:35 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44710 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbYDNNre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:47:34 -0400
Date: Mon, 14 Apr 2008 09:47:34 -0400
To: Tejun Heo <htejun@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080414134734.GB7385@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl> <200804021820.04610.elendil@planet.nl> <20080402194938.GI24237@csclub.uwaterloo.ca> <200804031947.07674.elendil@planet.nl> <48017248.4030600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48017248.4030600@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 11:39:04AM +0900, Tejun Heo wrote:
> Please be advised that some modern controllers are dual interfaced. 
> Native one and legacy one.  The legacy one is SFF compliant and 
> depending on configuration may appear at legacy IO addresses, so if you 
> aren't careful, you can end up with two drivers driving the same 
> hardware which usually doesn't end too well.  Loading generic drivers 
> w/o knowing that it's needed is quite dangerous.  I would strongly 
> advise against it.

If you can't safely load the generic driver then the kernel is very
broken and needs fixing.

After all there is no reason I couldn't have multiple IDE controllers,
some of which have dual interfaces, and some of which only have the old
generic interface (like the IDE port on my old ISA sound card).

If a driver supports a device with dual interfaces, then it better
reserve both sets of ports to prevent the generic driver from trying to
use them.

-- 
Len Sorensen
