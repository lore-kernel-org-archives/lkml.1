Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbXHVNFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbXHVNFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 09:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbXHVNFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 09:05:22 -0400
Received: from iona.labri.fr ([147.210.8.143]:55153 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbXHVNFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 09:05:21 -0400
Date: Wed, 22 Aug 2007 15:05:20 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Console events and accessibility
Message-ID: <20070822130520.GE3359@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070821212939.GD3658@interface.famille.thibault.fr> <20070822054855.GB23336@kroah.com> <20070822085355.GB3359@implementation.labri.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070822085355.GB3359@implementation.labri.fr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Wed 22 Aug 2007 10:53:55 +0200, a écrit :
> Greg KH, le Tue 21 Aug 2007 22:48:55 -0700, a écrit :
> > On Tue, Aug 21, 2007 at 11:29:39PM +0200, Samuel Thibault wrote:
> > > Some external modules like Speakup need to monitor console output.
> > > 
> > > This adds a VT notifier that such modules can use to get console output events:
> > > allocation, deallocation, writes, other updates (cursor position, switch, etc.)
> > > 
> > > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> > 
> > Will speakup work with this kind of change?
> 
> Here are the last needed bits.

I mean: yes, with these three patches, speakup will work fine.

The biggest change we'll have to do in speakup is the way it accesses
the serial port, which is really dirty for now, but that's an internal
matter.

Samuel
