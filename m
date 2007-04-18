Return-Path: <linux-kernel-owner+w=401wt.eu-S2992511AbXDRUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992511AbXDRUMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992506AbXDRUMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:12:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56633
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992486AbXDRUMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:12:18 -0400
Date: Wed, 18 Apr 2007 13:12:21 -0700 (PDT)
Message-Id: <20070418.131221.35665053.davem@davemloft.net>
To: hch@infradead.org
Cc: seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com, ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070418171632.GB16471@infradead.org>
References: <20070416.220208.94071670.davem@davemloft.net>
	<A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
	<20070418171632.GB16471@infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 18 Apr 2007 18:16:32 +0100

> On Tue, Apr 17, 2007 at 11:28:07AM -0700, Seokmann Ju wrote:
> > Hello David,
> > On Mon 4/16/2007 10:02 PM, David Miller wrote:
> > > > I'm in transit for a redeye to NY so I won't be able to modify the 
> > > > patch, If you would be amenable to the above, Seokmann, could you 
> > > > rework the patch?
> > > 
> > > Thanks guys.
> > Here, I've attached updated patch. Please take this.
> > Sorry for late.
> 
> I don't think there should be a warning in the sparc case where the
> wwn's are stored in the device tree.  This is the way sun intended
> the hardware to work on sparc.  

Yep, that's the main point.

Sun provides device parameters via openprom properties in lieu
of existing mechanisms chip vendors usually use for this on
other platforms such as NVRAM and the BIOS.

They do this for just about every scsi, networking, and video
chip.  It works this way on PowerPC as well.
