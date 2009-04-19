Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbZDSQgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbZDSQgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZDSQgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:36:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41921 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbZDSQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:36:11 -0400
Date: Sun, 19 Apr 2009 18:39:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] Wait for console to become available, v2
Message-ID: <20090419163923.GS14687@one.firstfloor.org>
References: <20090416190837.GA26734@cuplxvomd02.corp.sa.net> <874owlqcce.fsf@basil.nowhere.org> <49EB5008.1090000@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EB5008.1090000@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 09:23:36AM -0700, David VomLehn wrote:
> Andi Kleen wrote:
> >VomLehn <dvomlehn@cisco.com> writes:
> >>History
> >>v2	Wait for the preferred console rather than any console. Make the
> >>	delay interval a tunable.
> >
> >CONFIG tunables are usually a bad idea. What should a binary distribution
> >kernel set? Better make it a boot option with a reasonable default.
> 
> Your point about boot options is well taken; I released a more recent 
> version of this patch with boot options last Friday and would appreciate 
> your comments.

Ah missed that sorry.

> 
> >Also a setting to panic in this case might be useful, normally a system
> >without console is not very useful and needs to be rebooted anyways.
> 
> Umm, those of us in the embedded space have the, perhaps misguided, 
> notion that our systems are quite useful without consoles...

That seems more like a special case that shouldn't be default?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
