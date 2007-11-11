Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbXKKIf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbXKKIf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 03:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXKKIfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 03:35:14 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:14779 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbXKKIfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 03:35:12 -0500
Date: Sun, 11 Nov 2007 10:35:01 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86 pci-calgary_64.c: make a variable static
Message-ID: <20071111083501.GG30021@rhun.ibm.com>
References: <20071109060330.GX26163@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109060330.GX26163@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 07:03:30AM +0100, Adrian Bunk wrote:
> "debugging" is a horrible name for a global variable - thankfully it can 
> become static.
> 
> Also put it out of __read_mostly so that gcc no longer has to emit it
> at all.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, applied. Will push with my next batch of Calgary updates.

Cheers,
Muli
