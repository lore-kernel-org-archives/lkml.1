Return-Path: <linux-kernel-owner+w=401wt.eu-S932605AbZIDQPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbZIDQPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZIDQPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:15:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44331 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054AbZIDQPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:15:09 -0400
Date: Fri, 4 Sep 2009 17:15:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Add a boot option to disable cursor on boot
Message-ID: <20090904161507.GA24697@srcf.ucam.org>
References: <1252079289-5383-1-git-send-email-mjg@redhat.com> <20090904180302.6561fabf@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904180302.6561fabf@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 06:03:02PM +0100, Alan Cox wrote:

> Seems odd to me - why can't the splash screen app in initrd just issue
> the call to turn off the cursor - or is this splash screen coming from
> something else ?

The kernel unconditionally enables the cursor before any userspace has 
run, even if we've turned it off in the bootloader. That's the window 
I'm trying to close.

> - If the splash screen is kernel based then the splash screen module
>   needs to be able to ask the vt driver itself
> - If not then the user space can use ioctls like everyone else (see
>   setterm)

(see above)

> - It should be implemented without adding an extra condition to a pile of
>   ifs (or the condition mess at least become a single cursor_visible_p())

It doesn't add or alter any conditionals in its current form?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
