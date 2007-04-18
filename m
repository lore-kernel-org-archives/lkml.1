Return-Path: <linux-kernel-owner+w=401wt.eu-S2992894AbXDRRQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992894AbXDRRQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992892AbXDRRQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:16:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38178 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992885AbXDRRQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:16:35 -0400
Date: Wed, 18 Apr 2007 18:16:32 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: David Miller <davem@davemloft.net>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com,
       ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
Message-ID: <20070418171632.GB16471@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Seokmann Ju <seokmann.ju@qlogic.com>,
	David Miller <davem@davemloft.net>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	James.Bottomley@SteelEye.com, ema@debian.org
References: <20070416.220208.94071670.davem@davemloft.net> <A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 11:28:07AM -0700, Seokmann Ju wrote:
> Hello David,
> On Mon 4/16/2007 10:02 PM, David Miller wrote:
> > > I'm in transit for a redeye to NY so I won't be able to modify the 
> > > patch, If you would be amenable to the above, Seokmann, could you 
> > > rework the patch?
> > 
> > Thanks guys.
> Here, I've attached updated patch. Please take this.
> Sorry for late.

I don't think there should be a warning in the sparc case where the
wwn's are stored in the device tree.  This is the way sun intended
the hardware to work on sparc.  

