Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXIUObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXIUObT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbXIUObJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:31:09 -0400
Received: from usul.saidi.cx ([204.11.33.34]:55076 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752768AbXIUObH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:31:07 -0400
Message-ID: <46F3D5A3.1070201@overt.org>
Date: Fri, 21 Sep 2007 07:30:59 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: sdhci-devel@list.drzeus.cx, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Disabler for Ricoh MMC controller
References: <46EC3860.3070600@overt.org> <20070920182429.247b28fb@poseidon.drzeus.cx>
In-Reply-To: <20070920182429.247b28fb@poseidon.drzeus.cx>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
>>
> 
> Patch looks ok. Please try to sort out that completely disabled
> controller that was reported first though.

This remains confusing. I went and investigated and the SD disable
bit is 0x20. The one lspci dump from the IFL90 shows that 0x80 is
set by default, but setting this on my laptop did not disable the
SD controller. I will need to collect more information from owners
to find out what's really going on.

Do you want to wait on this before taking this patch?

--phil
