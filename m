Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbXJ0Adg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbXJ0Adg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 20:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXJ0Ad2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 20:33:28 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33005 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXJ0Ad2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 20:33:28 -0400
Date: Fri, 26 Oct 2007 18:33:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, willy@linux.intel.com,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
Message-ID: <20071027003326.GV27248@parisc-linux.org>
References: <11932286982175-git-send-email-matthew@wil.cx> <1193228698799-git-send-email-matthew@wil.cx> <20071026114515.6e90222c.akpm@linux-foundation.org> <20071026203941.GA15427@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026203941.GA15427@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 12:39:41AM +0400, Alexey Dobriyan wrote:
> > > -		if ((task->state != TASK_STOPPED) && (task->state != TASK_TRACED)) {
> > > +		if (!is_task_stopped_or_traced(task)) {
>                      ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> I think this is horrible. Are you going to add full blown static inline
> function for every combination of state tests?

No, because we don't need them.  Just stopped, traced, stopped_or_traced.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
