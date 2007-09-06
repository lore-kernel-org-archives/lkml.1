Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbXIFP5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbXIFP5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbXIFP5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 11:57:46 -0400
Received: from ns.suse.de ([195.135.220.2]:38140 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbXIFP5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 11:57:45 -0400
From: Andreas Schwab <schwab@suse.de>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: udev: Inconsistency between %b and %p?
References: <fbp6a3$k6r$1@sea.gmane.org>
X-Yow: First, I'm going to give you all the ANSWERS to today's test..
 So just plug in your SONY WALKMANS and relax!!
Date: Thu, 06 Sep 2007 17:57:44 +0200
In-Reply-To: <fbp6a3$k6r$1@sea.gmane.org> (Manuel Reimer's message of "Thu\, 06
	Sep 2007 17\:33\:44 +0200")
Message-ID: <jeodgfu6pz.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Reimer <Manuel.Spam@nurfuerspam.de> writes:

> As I would prefer to use the USB device information (idVendor, idProduct)
> to detect the device, I also tried this one:
>
> ATTRS{idVendor}=="0dda", ATTRS{idProduct}=="2005", SUBSYSTEM=="scsi",
> ACTION=="add", PROGRAM+="/usr/bin/test.sh %b %p"
>
> Now this version returns the USB device ID ($NUM-$NUM) to the test script,
> but the device path (%p) is still OK and still goes down up to the SCSI
> device ID.
>
> Why does %b not return the SCSI device ID in the second rule?

Because ATTRS has matched the USB device, not the SCSI device.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
