Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbXDWQTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbXDWQTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXDWQTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:19:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbXDWQTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:19:01 -0400
Date: Mon, 23 Apr 2007 12:18:48 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: Prevent softlockup triggering in nvidiafb
Message-ID: <20070423161848.GA27649@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Antonino Daplas <adaplas@pol.net>
References: <20070423151053.GA5653@redhat.com> <20070423165505.4aecd186@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423165505.4aecd186@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 04:55:05PM +0100, Alan Cox wrote:
 > On Mon, 23 Apr 2007 11:36:30 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > If the chip locks up, we get into a long polling loop,
 > > where the softlockup detector kicks in.
 > > See https://bugzilla.redhat.com/bugzilla/attachment.cgi?id=151878
 > > for an example.
 > 
 > Surely in this situation the softlockup report and trap out is precisely
 > what should be occurring.

We can't do anything useful with the trace.  It already prints out
info that the hardware locked up.

	Dave

-- 
http://www.codemonkey.org.uk
