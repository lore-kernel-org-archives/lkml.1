Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbXHRAMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbXHRAMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 20:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXHRAMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 20:12:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:47478 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbXHRAMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 20:12:07 -0400
Date: Fri, 17 Aug 2007 17:11:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
	issue
Message-ID: <20070818001145.GT3672@sequoia.sous-sol.org>
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C637B7.30200@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> This patch breaks Xen booting.  I get infinite recursive faults during
> patching when this patch is present.  If I boot with
> "noreplace-paravirt" it works OK, and it works as expected if I back
> this patch out.  I haven't tracked down the exact failure mode; its a
> little hard to debug because it overwrites all kernel memory with
> recursive fault stackframes and then finally traps out to Xen when it
> hits the bottom of memory.
> 
> I think we should back this one out before .23.

I agree (second time this has broken during .23 devel).

thanks,
-chris
