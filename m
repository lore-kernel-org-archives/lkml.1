Return-Path: <linux-kernel-owner+w=401wt.eu-S932955Ab0AFWAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab0AFWAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932946Ab0AFWAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:00:37 -0500
Received: from outbound-mail-10.bluehost.com ([69.89.17.210]:34583 "HELO
	outbound-mail-10.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932917Ab0AFWAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:00:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WpMFyL66+pe/PEOiLXNcLLweXxzTSou2SimwNGfX+YYCP+7zJgKsim4qWpmun4S1zuryPpilF/LwS4B8p6V0rtBDtexBVXaiYOgUH9rB/MdbubkBqk7ZV2APJebSJa8Y;
Date: Wed, 6 Jan 2010 14:00:35 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [PATCH 9/12] ACPI / PM: Introduce acpi_pm_wakeup_power()
Message-ID: <20100106140035.6f622acf@jbarnes-piketon>
In-Reply-To: <200912272106.26569.rjw@sisk.pl>
References: <200912272057.10443.rjw@sisk.pl>
	<200912272106.26569.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 21:06:26 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>  /**
> + * acpi_pm_wakeup_power - Enable/disable device wake-up power.
> + * @dev: ACPI device to handle.
> + * @enable: Whether to enable or disable the wake-up power of the
> device.
> + */
> +int acpi_pm_wakeup_power(struct acpi_device *dev, bool enable)
> +{

I know we've got these all over now, but functions that just take a
bool are generally hard to read when you just look at the call site.
If it was called "acpi_pm_set_wakeup_power" and then took an on/off
enum it would be really easy to see, from the callsite, what was going
on.

It's a fairly minor complaint, but it's something that's always bugged
me about the PCI PM code in particular.

-- 
Jesse Barnes, Intel Open Source Technology Center
