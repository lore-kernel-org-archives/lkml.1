Return-Path: <linux-kernel-owner+w=401wt.eu-S1422639AbXBAIC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422639AbXBAIC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030540AbXBAIC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:02:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46814 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030520AbXBAIC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:02:57 -0500
Date: Thu, 1 Feb 2007 09:01:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Andrew Morton <akpm@osdl.org>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070201080108.GC14378@elte.hu>
References: <20070129204528.eb8d695e.akpm@osdl.org> <200701310155.05474.fzu@wemgehoertderstaat.de> <20070131132245.GA26066@elte.hu> <200701311525.50160.fzu@wemgehoertderstaat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701311525.50160.fzu@wemgehoertderstaat.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4622]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Karsten Wiese <fzu@wemgehoertderstaat.de> wrote:

> Serial port console is off here and the jiffies update fix doesn't 
> make a noticeable difference.

ok, this eliminates my serial port theory.

and this means i'm having trouble reproducing this problem locally. 
Maybe i tried it the wrong way: does it only occur with suspend-to-disk, 
or suspend-to-ram too? Does it need ACPI suspend-to-disk, or 
software-suspend?

	Ingo
