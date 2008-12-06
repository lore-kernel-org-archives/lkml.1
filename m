Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYLFTbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYLFTbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 14:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYLFTbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 14:31:02 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:13155 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbYLFTbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 14:31:00 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/3] Fix hibernation regression on Toshiba Portege R500
Date: Sat, 6 Dec 2008 20:30:55 +0100
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       jbarnes@virtuousgeek.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
       tiwai@suse.de, akpm@linux-foundation.org,
       linux-pm@lists.linux-foundation.org
References: <200812020320.31876.rjw@sisk.pl> <200812020320.31876.rjw@sisk.pl> <200812061505.33815.rjw@sisk.pl>
In-reply-To: <200812061505.33815.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812062030.57914.elendil@planet.nl>
X-OriginalArrivalTime: 06 Dec 2008 19:30:58.0528 (UTC) FILETIME=[2A425600:01C957D9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following three patches address the hibernation/suspend issue
> described in http://bugzilla.kernel.org/show_bug.cgi?id=12121 and in
> the very long thread at http://lkml.org/lkml/2008/12/1/382.

I've just built a kernel with your three patches, and without the earlier
"revert/debug" and "ignore transparent bridge" patches.

It also includes my patch that somewhat improves USB resume and my fix for 
the ohci1394: "irq 19: nobody cared" issue. (Although I understand that 
it's likely we'll get a much more structural improvement for USB than my 
naive patch.)

I'll run my notebook with this kernel for the next few days and let you 
know the results. First suspend/resume cycle was fine and showed, as 
expected, a lot of config restores moved up, including HDA intel and 
pcieport-driver.

It's nice to see something of significance happening before the ricoh-mmc 
controller gets disabled :-P

Cheers,
FJP
