Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbYFBLDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbYFBLDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYFBLD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:03:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43001 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYFBLD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:03:28 -0400
Date: Mon, 2 Jun 2008 13:03:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, davej@elf.ucw.cz,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend vs. iommu: prevent suspend if we could not resume
Message-ID: <20080602110310.GD14598@elte.hu>
References: <20080527095121.GA3689@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527095121.GA3689@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> iommu/gart support misses suspend/resume code, which can do bad stuff, 
> including memory corruption on resume. Prevent system suspend in case 
> we would be unable to resume.

applied to tip/x86/urgent and to tip/pci-for-jesse. Thanks Pavel,

	Ingo
