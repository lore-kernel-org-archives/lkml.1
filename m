Return-Path: <linux-kernel-owner+w=401wt.eu-S1763736AbZEAPyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763736AbZEAPyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbZEAPyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:54:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:37579 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774AbZEAPym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:54:42 -0400
Date: Fri, 1 May 2009 17:54:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Oliver Neukum <oliver@neukum.org>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: What's in hid.git for 2.6.30
In-Reply-To: <200905011102.18945.oliver@neukum.org>
Message-ID: <alpine.LNX.2.00.0905011751180.5012@wotan.suse.de>
References: <alpine.LNX.2.00.0903251742520.14346@wotan.suse.de> <200905010102.34272.oliver@neukum.org> <alpine.LNX.2.00.0905010103550.5012@wotan.suse.de> <200905011102.18945.oliver@neukum.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-202102907-1241193279=:5012"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-202102907-1241193279=:5012
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 1 May 2009, Oliver Neukum wrote:

> > > > +       if (!(hid->claimed & HID_CLAIMED_INPUT))
> > > > +               return 0;
> > > > +
> > > is there a guarantee all keyboards will be claimed as input devices?
> > do you see any way how hid->inputs could currently be initialized other
> > than the device being claimed by hid-input?
> No, but I am worried about a false return of 0 here, not the other way
> round. This method is necessary because keyboards don't wake up
> if a key is released. Suspending a keyboard with a key pressed will lead
> to an endless repetition of that key.
> So I wonder whether it is possible to have a keyboard not claimed as an
> input device.

If driven by usbhid, the only way how keyboard could be handled if not 
claimed by hid-input is a userspace hiddev or hidraw driver. And we don't 
suspend if hidraw/hiddev node is open, right?

-- 
Jiri Kosina
SUSE Labs
--168427776-202102907-1241193279=:5012--
