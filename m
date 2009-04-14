Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbZDNQ5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbZDNQ5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbZDNQ5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:57:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:52105 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbZDNQ5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:57:16 -0400
Date: Tue, 14 Apr 2009 09:40:29 -0700
From: Greg KH <gregkh@suse.de>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: arjan@linux.intel.com, jmorris@namei.org, alan@redhat.com,
       hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: current->mm == NULL in security_vm_enough_memory().
Message-ID: <20090414164029.GC4791@suse.de>
References: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp> <alpine.LRH.2.00.0903261236580.30336@tundra.namei.org> <200904092105.HBG52601.MHFOtQOLSVFOFJ@I-love.SAKURA.ne.jp> <200904132127.FBG30222.OOFFtQLJFOHSMV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904132127.FBG30222.OOFFtQLJFOHSMV@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 09:27:29PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I'm experiencing
> 
>   WARNING: at security/security.c:217 security_vm_enough_memory+0xa0/0xb0()
> 
> messages.
> "git bisect" reported that commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
> is the cause of this warning. May I ignore this warning?

I don't know, can you provide the full warning?

And what kernel version is this happening on?

thanks,

greg k-h
