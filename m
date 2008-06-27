Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYF0CYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYF0CYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 22:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYF0CYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 22:24:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47461 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYF0CYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 22:24:24 -0400
Date: Thu, 26 Jun 2008 20:24:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Daniel Walker <dwalker@mvista.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush requirements
Message-ID: <20080627022407.GB7703@parisc-linux.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <1214512405.21035.110.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214512405.21035.110.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 01:33:25PM -0700, Daniel Walker wrote:
> I think there is some basis to make the changes that you have here.
> Specifically this email and thread,
> 
> http://lkml.org/lkml/2008/4/15/232

You've completely missed the point.  The current semaphore code is
_more_ efficient than the current completion code.  I'm very comfortable
having two APIs here, one for completion-like semantics and one for
mutex-like semantics.  Confusing them like this makes no sense at all.

> However, I don't like how your implementing this as specifically a
> "flush" mechanism for XFS, and the count is limited to just 1 .. There
> are several other places that do this kind of counting with semaphores,
> and have counts above 1..

Then leave them as semaphores.  Really.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
