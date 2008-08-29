Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYH2Lay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYH2Lay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYH2Lap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:30:45 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:5111 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078AbYH2Lao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:30:44 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: SATA disk double spin-off during hibernation on hp nx6325
Date: Fri, 29 Aug 2008 13:30:40 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org, trenn@suse.de,
       htejun@gmail.com, hancockr@shaw.ca, linux-kernel@vger.kernel.org
References: <200808290002.55026.rjw@sisk.pl> <200808291245.27436.elendil@planet.nl> <200808291257.33690.rjw@sisk.pl>
In-Reply-To: <200808291257.33690.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291330.42265.elendil@planet.nl>
X-OriginalArrivalTime: 29 Aug 2008 11:30:42.0511 (UTC) FILETIME=[ABADD5F0:01C909CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Rafael J. Wysocki wrote:
> Suspend to RAM is fine, hibernation (aka suspend to disk) is not (on my
> box). Does it mean that hibernation is fine on your box with
> 2.6.27-rc5, although shutdown is not?  That would require special
> DMI-dependent handling, so please double check.

Ah, right. The double spin down happens during hibernation too.

> Anyway, please attach the output of dmidecode to
> http://bugzilla.kernel.org/show_bug.cgi?id=8855
> so I can include your box into the final version of the patch.

Done.
