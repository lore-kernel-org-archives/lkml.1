Return-Path: <linux-kernel-owner+w=401wt.eu-S2993040AbXEBLF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993040AbXEBLF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993048AbXEBLF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:05:27 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1883 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993040AbXEBLFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:05:25 -0400
Date: Wed, 2 May 2007 13:05:19 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Andi Kleen <ak@novell.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com,
       jesse.barnes@intel.com
Subject: Re: [PATCH] mmconfig: Some additional chipset register values validation.
Message-ID: <20070502110519.GA24043@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Andi Kleen <ak@novell.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, greg@kroah.com, jesse.barnes@intel.com
References: <20070502005011.GA41935@dspnet.fr.eu.org> <200705021152.36648.ak@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705021152.36648.ak@novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:52:36AM +0200, Andi Kleen wrote:
> On Wednesday 02 May 2007 02:50:11 Olivier Galibert wrote:
> > On i945, a mmconfig range hitting the f0000000-ffffffff zone conflicts
> > with the APIC registers and others.  Consider it invalid.
> > 
> > On E7520, values 0000 and f000 for the window register are defined
> > invalid in the documentation.
> 
> Added thanks

Oh, feel free to add the:
Signed-off-by: Olivier Galibert <galibert@pobox.com>

I forgot in the original mail.

  OG.
