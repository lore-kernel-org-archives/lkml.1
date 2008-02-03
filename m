Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbYBCLtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbYBCLtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbYBCLte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:49:34 -0500
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:39843 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759368AbYBCLtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:49:32 -0500
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86: restore correct module name for apm
Cc: lawrence_a_e@ntlworld.com, linux-kernel@vger.kernel.org, mingo@elte.hu
In-reply-To: <20080203103213.GC20810@uranus.ravnborg.org>
References: <47A4E70D.1000607@ntlworld.com> <20080203103213.GC20810@uranus.ravnborg.org>
Message-Id: <E1JLdLk-0001oF-4S@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sun, 03 Feb 2008 12:49:28 +0100
X-OriginalArrivalTime: 03 Feb 2008 11:49:30.0442 (UTC) FILETIME=[D60E72A0:01C8665A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> The apm module were renamed to apm_32 during the merge of 32 and 64 bit
> x86 which is unfortunate.
> As apm is 32 bit specific we like to keep the _32 in the filename
> but the module should be named apm.
> 
> Fix this in the Makefile.
> Reported by "A.E.Lawrence" <lawrence_a_e@ntlworld.com>
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "A.E.Lawrence" <lawrence_a_e@ntlworld.com>

I assume this will be pushed for stable 2.6.24 as well?

Cheers,
FJP
