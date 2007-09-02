Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbXIBEFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbXIBEFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 00:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXIBEFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 00:05:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55765 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbXIBEFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 00:05:22 -0400
Date: Sat, 1 Sep 2007 22:05:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
Message-ID: <20070902040519.GL14130@parisc-linux.org>
References: <20070902024348.GJ14130@parisc-linux.org> <11887012142333-git-send-email-matthew@wil.cx> <1188704106.11196.44.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188704106.11196.44.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 08:35:06PM -0700, Daniel Walker wrote:
> Does it take task->state or task ?

task.  Clearly I didn't test on ia64.  (There was an iteration where it
took task->state, and I guess I missed one).  Thanks for pointing out
this oops, I'll fix it for round three.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
