Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZDPHoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZDPHoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZDPHoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:44:14 -0400
Received: from eazy.amigager.de ([213.239.192.238]:54437 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZDPHoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:44:13 -0400
Date: Thu, 16 Apr 2009 09:44:11 +0200
From: Tino Keitel <tino.keitel+xorg@tikei.de>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] i915: Register ACPI video even when not
	modesetting
Message-ID: <20090416074411.GA22447@dose.home.local>
Mail-Followup-To: intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20090415204636.GA32365@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415204636.GA32365@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 21:46:36 +0100, Matthew Garrett wrote:
> The ACPI video driver defers registration to the i915 driver if the 
> system supports opregion-mediated backlight control. This registration 
> was only being performed in the KMS case. Ensure it's done even if we 
> don't have modesetting enabled.

Does this provide backlight control even without DRI enabled, or just
without KMS enabled?

Regards,
Tino
