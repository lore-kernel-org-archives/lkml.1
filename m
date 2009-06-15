Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZFOCqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZFOCqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZFOCqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:46:07 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47299 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZFOCqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:46:07 -0400
Date: Mon, 15 Jun 2009 11:45:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 4/17] cpumask: remove the now-obsoleted pcibus_to_cpumask(): sh
Message-ID: <20090615024520.GA31902@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
	Mike Travis <travis@sgi.com>
References: <20090612133105.E5D7ADDD0C@ozlabs.org> <20090612133058.E6FA7DDD0C@ozlabs.org> <20090612133109.90693DDD01@ozlabs.org> <20090612132556.EEAEADDD04@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612133105.E5D7ADDD0C@ozlabs.org> <20090612133058.E6FA7DDD0C@ozlabs.org> <20090612133109.90693DDD01@ozlabs.org> <20090612132556.EEAEADDD04@ozlabs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 10:31:04PM +0930, Rusty Russell wrote:
> cpumask_of_pcibus() is the new version.

On Fri, Jun 12, 2009 at 10:32:35PM +0930, Rusty Russell wrote:
> We're weaning the core code off handing cpumask's around on-stack.
> This introduces arch_send_call_function_ipi_mask(), and by defining
> it, the old arch_send_call_function_ipi is defined by the core code.

On Fri, Jun 12, 2009 at 10:33:14PM +0930, Rusty Russell wrote:
> Makes code futureproof against the impending change to mm->cpu_vm_mask.
> 
> It's also a chance to use the new cpumask_ ops which take a pointer
> (the older ones are deprecated, but there's no hurry for arch code).

On Fri, Jun 12, 2009 at 10:33:14PM +0930, Rusty Russell wrote:
> Use the accessors rather than frobbing bits directly (the new versions
> are const).

I've taken these in to the sh tree, thanks. They'll be included in the
next round of updates for -rc1.

I'm not sure how you want to handle the remaining patches. The
outstanding ones obviously touch code all over the place and should
probably go in in one go after the merge window has settled down a bit.
