Return-Path: <linux-kernel-owner+w=401wt.eu-S965100AbXAXBzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100AbXAXBzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 20:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965607AbXAXBzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 20:55:11 -0500
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:4855 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965100AbXAXBzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 20:55:10 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: Strange
Date: Wed, 24 Jan 2007 01:55:05 +0000
User-Agent: KMail/1.9.5
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <45B69D0C.8030501@scientia.net> <20070124000905.3a7b053d@localhost.localdomain> <45B6A1D4.7020906@scientia.net>
In-Reply-To: <45B6A1D4.7020906@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701240155.05501.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 January 2007 00:01, Christoph Anton Mitterer wrote:
> Alan wrote:
> >> kernel:   Error: Illegal request -- (Sense key=0x05)
> >> kernel:   Read of scrambled sector without authentication -- (asc=0x6f,
> >> ascq=0x03)
> >
> > The disc is using digital rights management. If you are in a country that
> > permits it you can use a dvd reader library with decss support, if not
> > you'll have to either watch your disks on a system approved by the movie
> > industry enforcers or commit a crime to read the disc.
>
> I knew of course about libdvdcss but I've never noticed before that the
> kernel issues these error messages to the syslog.

If you've replaced the drive, the decss keys might have changed for inserted 
media (this is especially true if your old drive had a different region 
setting).

First set the DVD region on the drive to where you are (probably 2), 
using "regionset". Then rm -rf ~/.dvdcss and restart your video playing 
application. It should rescan the dvd, figure out the keys, no error 
messages.

> So you say this is normal?! But the problem with ejecting isn't probably
> normal.

Yeah, like Alan says it's just the DRM nonsense built into your drive trying 
to "protect" the media. You can find firmware modifications which remove this 
logic from the drive, but I'm not sure of their legality.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
