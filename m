Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbXDPWeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbXDPWeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbXDPWeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:34:50 -0400
Received: from mga06.intel.com ([134.134.136.21]:8711 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753689AbXDPWet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:34:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,415,1170662400"; 
   d="scan'208"; a="228536811:sNHT18609920"
Date: Mon, 16 Apr 2007 15:34:42 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: David Chinner <dgc@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Repair-driven file system design (was Re: ZFS with Linux: An Open Plea)
Message-ID: <20070416223440.GA18590@nifty>
References: <op.tqthonq5ftfxs2@localhost.localdomain> <4622C851.2030509@redhat.com> <20070416030705.GY32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416030705.GY32602149@melbourne.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 01:07:05PM +1000, David Chinner wrote:
> On Sun, Apr 15, 2007 at 08:50:25PM -0400, Rik van Riel wrote:
>
> > IMHO chunkfs could provide a much more promising approach.
> 
> Agreed, that's one method of compartmentalising the problem.....

Agreed, the chunkfs design is only one way to implement repair-driven
file system design - designing your file system to make file system
check and repair fast and easy.  I've written a paper on this idea,
which includes some interesting projections estimating that fsck will
take 10 times as long on the 2013 equivalent of a 2006 file system,
due entirely to changes in disk hardware.  So if your server currently
takes 2 hours to fsck, an equivalent server in 2013 will take about 20
hours.  Eek!  Paper here:

http://infohost.nmt.edu/~val/review/repair.pdf

While I'm working on chunkfs, I also think that all file systems
should strive for repair-driven design.  XFS has already made big
strides in this area (multi-threading fsck for multi-disk file
systems, for example) and I'm excited to see what comes next.

-VAL
