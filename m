Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbYBTBI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbYBTBI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbYBTBIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:08:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYBTBIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:08:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 02:06:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <b6a2187b0802191653q4dfaa32cl96b9278e97606ef0@mail.gmail.com> <200802191700.12050.jesse.barnes@intel.com>
In-Reply-To: <200802191700.12050.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200206.57002.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of February 2008, Jesse Barnes wrote:
> I found the same poweroff issue on my T61.  It turned out to be related to the 
> C state code disabling interrupts when it shouldn't iirc.  Booting 
> with 'idle=poll' seems to work around the problem.

However, this issue is supposed to be fixed in 2.6.25-rc2, so most probably
there is another problem in there.

Thanks,
Rafael
