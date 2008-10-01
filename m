Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYJAJxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYJAJxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYJAJxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 05:53:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40016 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbYJAJxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 05:53:33 -0400
Date: Wed, 1 Oct 2008 10:53:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Pavel Machek <pavel@suse.cz>, carbonated beverage <ramune@net-ronin.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Thinkpad brightness keys kill X on 2.6.26.5
Message-ID: <20081001095322.GA27987@srcf.ucam.org>
References: <20080925060244.GA18945@net-ronin.org> <20080930231952.GB15903@ucw.cz> <48E2CB5A.1050809@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E2CB5A.1050809@goop.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 05:59:06PM -0700, Jeremy Fitzhardinge wrote:

> On my shiny new X200 running Fedora Rawhide, I'm finding that the 
> brightness control keys work OK, but the backlight remains stuck off 
> after a resume.  The machine is working fine but the backlight is just 
> off; I can see the display under a bright light.  Switching consoles and 
> poking about in /sys/class/backlight/acpi_video?/ didn't help.

Intel graphics, right? The DRM layer should handle full resume on modern 
Intel hardware, but there's the potential for bugs. This is entirely 
unrelated to ACPI, though.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
