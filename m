Return-Path: <linux-kernel-owner+w=401wt.eu-S1765893AbYBUBIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765893AbYBUBIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbYBUBIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:08:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33479 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbYBUBIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:08:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 02:07:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Dave Airlie <airlied@linux.ie>,
       Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802210049.42820.rjw@sisk.pl> <200802201617.51387.jbarnes@virtuousgeek.org>
In-Reply-To: <200802201617.51387.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210207.16350.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Jesse Barnes wrote:
> On Wednesday, February 20, 2008 3:49 pm Rafael J. Wysocki wrote:
> > > And just to confirm that, I just tested the current DRM modules against a
> > > 2.6.23.15 kernel.
> >
> > In 2.6.23.x there's no second ->suspend() during hibernation, so no wonder.
> 
> In 2.6.23 it's just:
>   ->suspend()
>   ->resume()

->shutdown()

(that breaks wake up from S4 with many devices, including but not limited to
the RTC wake alarm).

>   *S4*
> ?
> 

Thanks,
Rafael
