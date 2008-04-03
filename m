Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbYDCJfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbYDCJfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 05:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbYDCJfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 05:35:45 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:24266 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbYDCJfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 05:35:44 -0400
Date: Thu, 3 Apr 2008 11:34:59 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: remove x86-specific implementations of find_first_bit
Message-ID: <20080403093459.GA28740@mailshack.com>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com> <20080401154126.GA26062@mailshack.com> <20080401154221.GB26062@mailshack.com> <20080401154757.GC26062@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401154757.GC26062@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Thu, 03 Apr 2008 11:35:25 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.80; VDF: 7.0.3.110; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 05:47:57PM +0200, Alexander van Heukelum wrote:
> This patch should of course wait until it is decided if the generic
> version is good enough to replace the x86-specific ones. I hacked
> together a benchmark that people can run on different machines. It can
> be downloaded from:
> 
>    http://heukelum.fastmail.fm/find_first_bit

I now put a much more sound benchmarking program there. And its
results for P-IV-like Xeon, Athlon XP and Opteron for the current
and generic implementations.

Greetings,
	Alexander
