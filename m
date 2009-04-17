Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbZDQAsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbZDQAsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbZDQAoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:44:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59600 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760916AbZDQAoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:44:17 -0400
Date: Fri, 17 Apr 2009 01:44:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] i915: Register ACPI video even when not modesetting
Message-ID: <20090417004413.GA869@srcf.ucam.org>
References: <20090415204636.GA32365@srcf.ucam.org> <20090416074411.GA22447@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416074411.GA22447@dose.home.local>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 09:44:11AM +0200, Tino Keitel wrote:
> On Wed, Apr 15, 2009 at 21:46:36 +0100, Matthew Garrett wrote:
> > The ACPI video driver defers registration to the i915 driver if the 
> > system supports opregion-mediated backlight control. This registration 
> > was only being performed in the KMS case. Ensure it's done even if we 
> > don't have modesetting enabled.
> 
> Does this provide backlight control even without DRI enabled, or just
> without KMS enabled?

Just without KMS being enabled. If your backlight control doesn't work 
without dri, that's because your backlight control requires a 
kernel-level component to change the backlight registers in response to 
an IRQ (ie, DRI)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
