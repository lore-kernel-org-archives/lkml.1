Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbZBGJUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbZBGJUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 04:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZBGJUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 04:20:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43534 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbZBGJUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 04:20:11 -0500
Date: Sat, 7 Feb 2009 10:19:56 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] PCI PM: Read power state from device after
	trying to change it on resume
Message-ID: <20090207091956.GC1411@ucw.cz>
References: <200902030141.28410.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902030141.28410.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-02-03 01:41:27, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> pci_restore_standard_config() unconditionally changes current_state
> to PCI_D0 after attempting to change the device's power state, but
> it should rather read the actual current power state from the
> device.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
