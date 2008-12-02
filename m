Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYLBRCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYLBRCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYLBRCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:02:30 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:9493 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbYLBRC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:02:29 -0500
Date: Tue, 2 Dec 2008 11:02:28 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 2/2] misc: Add dell-laptop driver
Message-ID: <20081202170228.GB9524@auslistsprd01.us.dell.com>
References: <20081127163357.GA22846@srcf.ucam.org> <20081127163444.GB22846@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127163444.GB22846@srcf.ucam.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 04:34:44PM +0000, Matthew Garrett wrote:
> Add a driver for controling Dell-specific backlight and rfkill interfaces.
> This driver makes use of the dcdbas interface to the Dell firmware to allow
> the backlight and rfkill interfaces on Dell systems to be driven through the
> standardised sysfs interfaces.

ack on the rfkill aspect.

For the backlight, right now, userspace HAL calls out to libsmbios to
modify the backlight settings.  Will this conflict?  Or is it HAL that
would decide to use either the standard sysfs interface if present,
falling back to libsmbios if not?

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
