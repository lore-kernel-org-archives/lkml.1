Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbYF1WqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbYF1WqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 18:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYF1Wpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 18:45:55 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65137 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbYF1Wpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 18:45:54 -0400
Date: Sat, 28 Jun 2008 18:45:29 -0400 (EDT)
From: Anders H Kaseorg <andersk@MIT.EDU>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: Patch paravirt inline replacements when loading
 modules
In-Reply-To: <4866BBC0.3000503@zytor.com>
Message-ID: <alpine.DEB.1.10.0806281836020.31023@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0806280431510.31023@vinegar-pot.mit.edu> <4866BBC0.3000503@zytor.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008, H. Peter Anvin wrote:
> Not having looked at this in detail, is this a *current* problem or a 
> *future* problem, i.e. does it fix a bug that's currently in the kernel?

It's a current problem.  The current situation is that .parainstructions 
are patched into the kernel core and modules on i386, but only the kernel 
core on x86_64.  This results in a slight performance regression in x86_64 
modules, compared to the situation before .parainstructions existed.  My 
patch restores full performance of x86_64 modules.

Anders

