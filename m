Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbYHFANT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbYHFANT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbYHFANH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:13:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59420 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbYHFANF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:13:05 -0400
Date: Wed, 6 Aug 2008 01:13:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Add Intel ACPI IGD OpRegion support
Message-ID: <20080806001301.GA10630@srcf.ucam.org>
References: <20080805183725.GA4468@srcf.ucam.org> <1217965470.5449.4.camel@hidalgo> <1217972874.4540.3.camel@hidalgo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217972874.4540.3.camel@hidalgo>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 11:47:54PM +0200, Yves-Alexis Perez wrote:

> In booted into X (with hal, powersaved, dbus etc. running), and then,
> tada, brightness keys work. There is a 750ms (I guess) delay, and I
> don't know who is really responsible, I guess X is. (and thus I guess
> the opregion is the one needed, and X manages the brightness. If the
> kernel was, it would be working even in single user)

The 750ms delay is from thinkpad-acpi. I sent a patch to Henrique which 
makes it go away, but I'm not entirely sure what the ACPI method 
concerned is supposed to be doing. The opregion code won't currently run 
until X is started because the drm layer requires X to be the foreground 
vt before handling IRQs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
