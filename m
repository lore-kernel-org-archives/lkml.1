Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYLJNY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYLJNY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYLJNYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:24:49 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:37075 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753674AbYLJNYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:24:48 -0500
From: Frans Pop <elendil@planet.nl>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
Date: Wed, 10 Dec 2008 14:24:41 +0100
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200812061316.38460.elendil@planet.nl> <493B953F.3070504@s5r6.in-berlin.de> <493C1C8F.5070003@shaw.ca>
In-Reply-To: <493C1C8F.5070003@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101424.42755.elendil@planet.nl>
X-OriginalArrivalTime: 10 Dec 2008 13:24:42.0955 (UTC) FILETIME=[A97301B0:01C95ACA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 December 2008, Robert Hancock wrote:
> Stefan Richter wrote:
> > Robert Hancock wrote:
> >> Presumably it should.. but the fact remains that if free_irq helps
> >> anything, then the device must be generating interrupts for some
> >> reason,
> >
> > Or another device:
> > http://www.gossamer-threads.com/lists/linux/kernel/896053
>
> Hmm, that case sounds like disable_irq on an MSI device redirecting the
> interrupts to the legacy INTx interrupt instead of actually disabling
> them? If this is what's happening here, then that's the bug..

Any suggestions how to try and trace if that's what's happening?
