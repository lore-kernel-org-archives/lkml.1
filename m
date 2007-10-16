Return-Path: <linux-kernel-owner+w=401wt.eu-S1765476AbXJPNBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765476AbXJPNBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbXJPNBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 09:01:14 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:45273 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbXJPNBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 09:01:13 -0400
Date: Tue, 16 Oct 2007 14:00:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
Message-ID: <20071016130053.GA20010@srcf.ucam.org>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015210737.GA15293@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 07:07:37PM -0200, Henrique de Moraes Holschuh wrote:

> And the input subsystem maintainer has made it extremely clear in various
> threads that the input devices are *not* to be used as a notification
> service for on-screen-display or other such stuff.  If you send volume and
> brightness *key* events to userspace, it is supposed to act on them and
> raise/lower brightness/volume, which is the wrong thing to do on thinkpads.
> Never mind that HAL is ignoring the input maintainer's directions and
> violating this.

Reality disagrees. There are already several cases where notifications 
are sent via the keyboard controller, such as the wireless and touchpad 
disable keys on my HP. There are Dells that do the same for brightness 
keys. Unless you want to make the argument that sending keyboard 
controller events through the input layer is the wrong thing to do, it's 
impossible to standardise on a setup where we never see notifications 
through it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
