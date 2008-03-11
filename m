Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYCKI0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYCKI0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYCKI0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:26:08 -0400
Received: from www.tglx.de ([62.245.132.106]:59106 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYCKI0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:26:07 -0400
Date: Tue, 11 Mar 2008 09:25:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH REPOST for 2.6.25] Use an own random generator for
 pageattr-test.c
In-Reply-To: <20080311013014.GA28682@basil.nowhere.org>
Message-ID: <alpine.LFD.1.00.0803110922430.3781@apollo.tec.linutronix.de>
References: <20080311013014.GA28682@basil.nowhere.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Andi Kleen wrote:
> Use an own random generator for pageattr-test.c
> 
> [Repost. Please ack/nack. This is a bug fix and imho a .25 late merge 
> candidate because it fixes a subtle bug]

Care to point out which "subtle bug" is fixed ? 

You replace a random generator by another to get repeateable
sequences. The non repeatability of the cpa test patterns is hardly a
"subtle bug".

Thanks,

	tglx
