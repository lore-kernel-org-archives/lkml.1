Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbZDMV0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbZDMV0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZDMV0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:26:39 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:61673 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbZDMV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:26:38 -0400
From: Frans Pop <elendil@planet.nl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/2] toshiba-acpi: Add support for hotkey notifications
Date: Mon, 13 Apr 2009 23:26:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org, lenb@intel.com
References: <20090331214501.GC29489@srcf.ucam.org> <200904132238.11401.elendil@planet.nl> <20090413211800.GA17922@srcf.ucam.org>
In-Reply-To: <20090413211800.GA17922@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904132326.36303.elendil@planet.nl>
X-OriginalArrivalTime: 13 Apr 2009 21:26:37.0166 (UTC) FILETIME=[86E278E0:01C9BC7E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 April 2009, Matthew Garrett wrote:
> On Mon, Apr 13, 2009 at 10:38:09PM +0200, Frans Pop wrote:
> > On Monday 13 April 2009, Matthew Garrett wrote:
> > > Hm. Do you get events for the multimedia keys without this patch
> > > and using the old interface?
> >
> > Yes, 2.6.28 gives in /proc/acpi/toshiba/keys as value for 'hotkey':
> > previous track:	0x0b31
> > next track:	0x0b32
> > play/pause:	0x0b33
> > stop:		0x0b30
>
> Without running any software, does hitting these keys cause the acpi
> interrupt in /proc/interrupts to increment?

Yes (with 2.6.28; fnfx* purged before system boot).
