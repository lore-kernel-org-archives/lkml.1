Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYJXEV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYJXEV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYJXEVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:21:50 -0400
Received: from kroah.org ([198.145.64.141]:42770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750725AbYJXEVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:21:49 -0400
Date: Thu, 23 Oct 2008 21:19:17 -0700
From: Greg KH <greg@kroah.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27.3 usbcore] Move __module_param_call(nousb) to
	immediately after declaration of nousb.
Message-ID: <20081024041917.GA16594@kroah.com>
References: <200810240158.m9O1w2PX032608@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810240158.m9O1w2PX032608@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 10:58:02AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I don't know the reason, but the below patch solves the problem which I'm
> experiencing with CONFIG_USB=y on Debian Sarge (gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)).
> 
> Something is wrong with sorting symbol table or walking sysfs tree?
> 
> Without this patch:

This really sounds like a compiler bug somewhere, reordering this
shouldn't "fix" this issue.  Is 3.3.5 still supported by the Debian
team?  I know the minimum gcc version is 3.2 for the kernel, so it's
strange that no one else sees this.

I've tried gcc 4.1.2 and 4.3.2 and can't see this either, so something
wierd is going on.

Can you duplicate this in a stand-alone test module?

thanks,

greg k-h
