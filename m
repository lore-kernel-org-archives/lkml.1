Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbZASWIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbZASWIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZASWIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:08:38 -0500
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:18961 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbZASWIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:08:37 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 6/6] SATA PIIX: Blacklist system that spins off disks during ACPI power off
Date: Mon, 19 Jan 2009 23:08:32 +0100
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <200901192053.50831.rjw@sisk.pl> <200901192059.23448.rjw@sisk.pl>
In-Reply-To: <200901192059.23448.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192308.34456.elendil@planet.nl>
X-OriginalArrivalTime: 19 Jan 2009 22:08:35.0124 (UTC) FILETIME=[79015F40:01C97A82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Some notebooks from HP have the problem that their BIOSes attempt to
> spin down hard drives before entering ACPI system states S4 and S5.
> This leads to a yo-yo effect during system power-off shutdown and the
> last phase of hibernation when the disk is first spun down by the
> kernel and then almost immediately turned on and off by the BIOS.
> This, in turn, may result in shortening the disk's life times.
>
> To prevent this from happening we can blacklist the affected systems
> using DMI information.
>
> Blacklist HP 2510p that uses the ata_piix driver.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

As I have a system that is affected by this and as I have been a happy 
user of this patch for 4 months or so, it may make sense to add my

Tested-by: Frans Pop <elendil@planet.nl>

Same goes indirectly for the rest of the series, except for patch 5.
