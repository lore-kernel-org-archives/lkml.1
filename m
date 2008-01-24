Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYAXG5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYAXG5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYAXG5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:57:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:52115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYAXG47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:56:59 -0500
From: Andi Kleen <ak@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] [2/8] GBPAGES: Add feature macros for the gbpages cpuid bit
Date: Thu, 24 Jan 2008 07:57:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <20080119748.170864000@suse.de> <20080119064830.5B00814EAD@wotan.suse.de> <Pine.LNX.4.64.0801232225590.12676@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801232225590.12676@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801240757.08851.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2008 22:26:35 Jan Engelhardt wrote:
> On Jan 19 2008 07:48, Andi Kleen wrote:
> >Subject: [PATCH] [2/8] GBPAGES: Add feature macros for the gbpages cpuid
> > bit
>
> Is there already a flag for /proc/cpuinfo or could you add one?

There is already one called pdpe1gb.  I don't think it's a very clear name, 
although AMD calls it the same. Calling it gbpages in /proc/cpuinfo would
have been probably better (and my old original patch did that too), but I 
didn't catch the new name submitted by someone else in time.

-Andi
