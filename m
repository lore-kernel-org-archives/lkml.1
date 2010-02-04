Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab0BDUFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:05:34 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48273 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab0BDUFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:05:33 -0500
Date: Thu, 4 Feb 2010 20:05:27 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       Len Brown <lenb@kernel.org>, Helge Deller <deller@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/9] x86: move hp-wmi's probe function to .devinit.text
Message-ID: <20100204200527.GA23497@srcf.ucam.org>
References: <20100203150850.GA28815@kroah.com> <1265313417-5568-4-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1265313417-5568-4-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 08:56:52PM +0100, Uwe Kleine-König wrote:
> A pointer to hp_wmi_bios_setup is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Frans Pop <elendil@planet.nl>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
