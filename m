Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZFEOuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZFEOuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZFEOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:50:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57124 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbZFEOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:50:12 -0400
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: alan-jenkins@tuffmail.co.uk
Cc: Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <9b2b86520906050738kea062c9n1b2c0e767d6eb0aa@mail.gmail.com>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
	 <1244205844.23533.21.camel@penberg-laptop>
	 <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>
	 <1244209873.23533.29.camel@penberg-laptop>
	 <9b2b86520906050738kea062c9n1b2c0e767d6eb0aa@mail.gmail.com>
Date: Fri, 05 Jun 2009 17:50:12 +0300
Message-Id: <1244213412.23533.41.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Fri, 2009-06-05 at 15:38 +0100, Alan Jenkins wrote:
> Ok.  I didn't bother shutting down my system, but I get a similar
> difference; 16 wakeups/s disabled v.s. 25 enabled.  Anecdotally,
> disabling the camera does help battery life, and presumably Asus had
> good reason to implement it!  (The shipped OS "fixes" the usability
> problem by patching the camera apps).
> 
> BUT I found that autosuspend didn't seem to break anything, and
> enabling it also got me down to 16 wakeups/s.  I think this is ideal
> because autosuspend is automatic so I can save power without manual
> toggling.
> 
> Here's some magic to enable autosuspend:
> 
> # echo -n auto > /sys/bus/usb/drivers/uvcvideo/*:*/../power/level
> 
> Ideally this wants to be enabled automatically using a udev rule.

Can the kernel do this by default for this specific driver on eeepc?

			Pekka

