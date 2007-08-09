Return-Path: <linux-kernel-owner+w=401wt.eu-S938550AbXHICmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938550AbXHICmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761941AbXHICmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:42:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55590 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760963AbXHICmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:42:24 -0400
Message-ID: <46BA7F0F.4000009@garzik.org>
Date: Wed, 08 Aug 2007 22:42:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ross Fawcett <claymen@parkingdenied.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sata_sil24 problems
References: <46BA6E79.8090706@parkingdenied.com> <46BA7ACB.20706@garzik.org> <46BA7CFB.8020605@parkingdenied.com>
In-Reply-To: <46BA7CFB.8020605@parkingdenied.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ross Fawcett wrote:
> What would you define a media error as though? I mean my first thought
> is a bad block, but a scan of the disc doesn't report anything like
> that. It also seems to be intermittent, however recently it has been
> reproducible.

It's not mine to define.  It's precisely what your device is reporting, 
no more, no less.

My -guess- would be surface error, quickly replaced by a spare sector, 
but who knows.

Run the '-t long' test in SMART, look at the various counters for signs 
of bad news like uncorrectable sectors, etc.

	Jeff



