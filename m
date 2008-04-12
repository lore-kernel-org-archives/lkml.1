Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYDLQ37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYDLQ37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYDLQ3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:29:51 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:47921 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1753975AbYDLQ3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:29:50 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 13 Apr 2008 02:29:40 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [LMB][1/2] Fix some whitespace and other formatting issues,	use pr_debug
Message-ID: <20080412162940.GB29599@tull.net>
References: <18432.18107.29491.115996@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18432.18107.29491.115996@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 03:20:59PM +1000, Paul Mackerras wrote:
> +	pr_debug("\n    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);

This will only output an empty line at KERN_DEBUG level and the rest
will be at default_message_loglevel. Problem is fixed my my patch in msg
<20080412161733.24882.30930.stgit@marcab.local.tull.net>

However, is a blank line in the log necessary?

Nick.
