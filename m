Return-Path: <linux-kernel-owner+w=401wt.eu-S1750847AbZDMUiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750847AbZDMUiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZDMUiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:38:14 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:61787 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522AbZDMUiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:38:14 -0400
From: Frans Pop <elendil@planet.nl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/2] toshiba-acpi: Add support for hotkey notifications
Date: Mon, 13 Apr 2009 22:38:09 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org, lenb@intel.com
References: <20090331214501.GC29489@srcf.ucam.org> <200904132128.54769.elendil@planet.nl> <20090413194341.GA16579@srcf.ucam.org>
In-Reply-To: <20090413194341.GA16579@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904132238.11401.elendil@planet.nl>
X-OriginalArrivalTime: 13 Apr 2009 20:38:12.0253 (UTC) FILETIME=[C36BECD0:01C9BC77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 April 2009, Matthew Garrett wrote:
> Hm. Do you get events for the multimedia keys without this patch and
> using the old interface?

Yes, 2.6.28 gives in /proc/acpi/toshiba/keys as value for 'hotkey':
previous track:	0x0b31
next track:	0x0b32
play/pause:	0x0b33
stop:		0x0b30

And fnfx-client in debug mode shows the four keys as well.
