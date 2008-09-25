Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYIYTKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYIYTKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYIYTJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:09:53 -0400
Received: from brak.cowlabs.com ([208.96.51.45]:46443 "EHLO brak.cowlabs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYIYTJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:09:52 -0400
Date: Thu, 25 Sep 2008 12:09:30 -0700
From: carbonated beverage <ramune@net-ronin.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_ACPI_VIDEO on Thinkpad blanks display.
Message-ID: <20080925190930.GA17184@net-ronin.org>
References: <20080925060244.GA18945@net-ronin.org> <20080925070741.GA22376@net-ronin.org> <20080925100746.GA13185@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925100746.GA13185@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 11:07:46AM +0100, Matthew Garrett wrote:
> > Without CONFIG_ACPI_VIDEO, the above message don't appear.  From this point,
> > any pointers on figuring out why the ACPI features makes the screen go blank?
> 
> Yes. X assumed that any ACPI key press was a request to switch the video 
> output. Upgrade X.

Since CONFIG_ACPI_VIDEO wasn't required before 2.6.26.x to change the LCD
brightness, I'd rather the kernel go back to whatever it was doing for
2.6.25.x.  Upgrading X past what's currently packaged by the distribution
just to get a new kernel working is somewhat of a pain.

What change linked the brightness keys to CONFIG_ACPI_VIDEO?

-- DN
Daniel
