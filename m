Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbYF1XRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbYF1XRE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 19:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYF1XQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 19:16:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYF1XQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 19:16:51 -0400
Message-ID: <4866C62A.2060808@zytor.com>
Date: Sat, 28 Jun 2008 16:15:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Anders H Kaseorg <andersk@MIT.EDU>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: Patch paravirt inline replacements when loading
 modules
References: <alpine.DEB.1.10.0806280431510.31023@vinegar-pot.mit.edu> <4866BBC0.3000503@zytor.com> <alpine.DEB.1.10.0806281836020.31023@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0806281836020.31023@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders H Kaseorg wrote:
> On Sat, 28 Jun 2008, H. Peter Anvin wrote:
>> Not having looked at this in detail, is this a *current* problem or a 
>> *future* problem, i.e. does it fix a bug that's currently in the kernel?
> 
> It's a current problem.  The current situation is that .parainstructions 
> are patched into the kernel core and modules on i386, but only the 
> kernel core on x86_64.  This results in a slight performance regression 
> in x86_64 modules, compared to the situation before .parainstructions 
> existed.  My patch restores full performance of x86_64 modules.

OK, it's a performance regression.  I don't think it makes sense for 
2.6.26, but it should definitely go into 2.6.27.

Thanks!

	-hpa

