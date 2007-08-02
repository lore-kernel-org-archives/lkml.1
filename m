Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbXHBQbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbXHBQbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbXHBQbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:31:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52243 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569AbXHBQbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:31:09 -0400
Date: Thu, 2 Aug 2007 18:32:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Fix section mismatch warnings in sound/pci/hda/
Message-ID: <20070802163226.GB2431@uranus.ravnborg.org>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B1D81F.4080802@googlemail.com> <s5h8x8urrw2.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8x8urrw2.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 03:24:29PM +0200, Takashi Iwai wrote:
> At Thu, 02 Aug 2007 15:11:59 +0200,
> Gabriel C wrote:
> > 
> > This patch fixes the following section mismatch warnings for sound/pci/hda/*
> > 
> > ...
> 
> Hold on this.  I have other changes in my tree with removal of
> __devinit in relevant places.

Can I ask you to text-compile with and without HOTPLUG before submitting.
This catches most cases of section mismatch.

	Sam
