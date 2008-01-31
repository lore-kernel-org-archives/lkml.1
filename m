Return-Path: <linux-kernel-owner+w=401wt.eu-S933627AbYAaSBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627AbYAaSBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762447AbYAaSBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:01:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36915 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760932AbYAaSBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:01:08 -0500
Date: Thu, 31 Jan 2008 19:35:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] GBPAGES: Fix global bit for 64bit
Message-ID: <20080131183534.GB4671@one.firstfloor.org>
References: <20080131131931.GA15586@basil.nowhere.org> <47A1FAC7.6030501@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A1FAC7.6030501@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Last time when my patch to do this was in the tree, it caused random 
> things to fail, even after increasing the strength of various tlb 
> flushes.  Did you change something to fix this?

At least all the flushes in init_64 are global now. 

But my latest iteration of gbpages actually doesn't need this patch anymore 
because I'm back to using PAGE_KERNEL_LARGE (without underscores) 

-Andi
