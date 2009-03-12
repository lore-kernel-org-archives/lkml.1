Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZCLPCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZCLPCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbZCLPCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:02:41 -0400
Received: from THUNK.ORG ([69.25.196.29]:42244 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235AbZCLPCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:02:40 -0400
Date: Thu, 12 Mar 2009 11:02:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4 problem on Linux-2.6.29-rc7-git4
Message-ID: <20090312150235.GD11748@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
	linux-kernel@vger.kernel.org
References: <49B7D979.7010406@turknet.net.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B7D979.7010406@turknet.net.tr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 05:32:09PM +0200, Tarkan Erimer wrote:
>
> After booting into new 2.6.29-rc7-git4, I got a lot of errors below in  
> dmesg. If it's a known issue or reported before, please ignore it.

It's a warning, not an error; but I didn't expect it to be quite so
voluminous in terms of log messages.  We have a proper fix for it
queued up for 2.6.30, but it was considered too invasive.  So the fix
was to print a warning which we ratelimited, but it looks like it's
even with the printk_ratelimit the warnings are too annoying to let
live.  I'll probably fix it to only printk the message once.

       	    	     	       	    	       - Ted
