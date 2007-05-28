Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbXE1SvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbXE1SvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 14:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbXE1SvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 14:51:08 -0400
Received: from main.gmane.org ([80.91.229.2]:58314 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXE1SvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 14:51:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [PATCH] RTC: Use fallback IRQ if PNP tables don't provide one
Date: Mon, 28 May 2007 18:50:22 +0000 (UTC)
Message-ID: <pan.2007.05.28.18.50.22@free.fr>
References: <20070527190351.GA21387@srcf.ucam.org>
	<20070527233911.GA23491@srcf.ucam.org>
	<20070528003822.GA23759@srcf.ucam.org>
	<200705271844.54589.david-b@pacbell.net>
	<20070528172418.GA2076@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cac94-1-81-57-151-96.fbx.proxad.net
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Mon, 28 May 2007 18:24:18 +0100, Matthew Garrett wrote:

> From: Matthew Garrett <mjg59@srcf.ucam.org>
> 
> Intel Macs (and possibly other machines) provide a PNP entry for the
> RTC, but provide no IRQ. As a result the rtc-cmos driver doesn't allow
> wakeup alarms. If the RTC is located at the legacy ioport range, assume
> that it's on IRQ 8 unless the tables say otherwise.
I post something via gmane this morning, but it seems it was lost :

Did you check if there aren't multiple configuration for rtc (one with 
irq, and
one without it) ?

What's the ouput of 
$ for i in /sys/bus/pnp/devices/*; do if [ "$(cat $i/id)" = PNP0b00 ]; 
then cat
$i/resources; echo options; cat $i/options; fi; done

Matthieu

