Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYDMMcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYDMMcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 08:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbYDMMb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 08:31:58 -0400
Received: from ozlabs.org ([203.10.76.45]:59708 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097AbYDMMb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 08:31:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18433.64824.293863.930250@cargo.ozlabs.ibm.com>
Date: Sun, 13 Apr 2008 22:31:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: Nick Andrew <nick@nick-andrew.net>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [LMB][1/2] Fix some whitespace and other formatting issues,	use pr_debug
In-Reply-To: <20080412162940.GB29599@tull.net>
References: <18432.18107.29491.115996@cargo.ozlabs.ibm.com>
	<20080412162940.GB29599@tull.net>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew writes:

> On Sat, Apr 12, 2008 at 03:20:59PM +1000, Paul Mackerras wrote:
> > +	pr_debug("\n    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
> 
> This will only output an empty line at KERN_DEBUG level and the rest
> will be at default_message_loglevel. Problem is fixed my my patch in msg
> <20080412161733.24882.30930.stgit@marcab.local.tull.net>
> 
> However, is a blank line in the log necessary?

No, and in fact the whole routine is probably not necessary any more.

Paul.
