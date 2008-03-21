Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYCUN2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYCUN2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYCUN16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:27:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbYCUN15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:27:57 -0400
Date: Fri, 21 Mar 2008 14:27:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080321132745.GK27245@elte.hu>
References: <20080320111429.GA14764@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320111429.GA14764@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> On 64-bit machine with 4GB ram (8core from amd), iommu breaks USB
> after swsusp. iommu=soft fixes that issue.
> 
> I guess iommu handling in arch/x86/kernel/ should have some
> suspend/resume support, as it manipulates hardware registers...?

agreed ...

	Ingo
