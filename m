Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYD0PrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYD0PrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 11:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYD0Pqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 11:46:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:7116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbYD0Pqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 11:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TrI5ccbQSxmahFPSxNsQOlOCL1SV+c0IUWv1z98dOeep+/k/2VVe3ZpQdLkBpvmRoMNSi/d8vt794DDF6GAd5Ur6gt4E5IO/lZBJIGm4Wu5xKTg957uVbV0G5YP8j9mWEnsBLGk8VdBsPIganfuDFhJxx/bA8FpjooKCIPjIIiA=
Date: Sun, 27 Apr 2008 19:46:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
Message-ID: <20080427154603.GA6895@cvg>
References: <200804181856.m3IIuKd4007403@hera.kernel.org> <480F7C11.8040302@zytor.com> <20080427100901.GC3891@ucw.cz> <200804271331.18940.rjw@sisk.pl> <20080427115536.GA20043@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427115536.GA20043@srcf.ucam.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Matthew Garrett - Sun, Apr 27, 2008 at 12:55:37PM +0100]
| On Sun, Apr 27, 2008 at 01:31:17PM +0200, Rafael J. Wysocki wrote:
| > On Sunday, 27 of April 2008, Pavel Machek wrote:
| > > I believe vbetool and thus s2ram uses vm86, too.
| > 
| > Well, I think so too. Matthew?
| 
| Yes, though I don't think any of them use these internal flags.
| 
| -- 
| Matthew Garrett | mjg59@srcf.ucam.org
| 

Originally this flag was bounded by CONFIG_VM86 which is
kernel internal feature and if userland program relies on
this it's a bit buggy assumption meguess. Anyway, i've posted
second version of the patch (don't remember lkml.org link for
that).
		- Cyrill -
