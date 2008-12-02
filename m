Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYLBREF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYLBREF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYLBRDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:03:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46270 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYLBRDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:03:52 -0500
Date: Tue, 2 Dec 2008 17:03:48 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 2/2] misc: Add dell-laptop driver
Message-ID: <20081202170348.GA19912@srcf.ucam.org>
References: <20081127163357.GA22846@srcf.ucam.org> <20081127163444.GB22846@srcf.ucam.org> <20081202170228.GB9524@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202170228.GB9524@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 11:02:28AM -0600, Matt Domsch wrote:

> For the backlight, right now, userspace HAL calls out to libsmbios to
> modify the backlight settings.  Will this conflict?  Or is it HAL that
> would decide to use either the standard sysfs interface if present,
> falling back to libsmbios if not?

hal will currently provide both interfaces and it'll then be up to 
userspace to decide which to use. In future, the libsmbios code can be 
deprecated.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
