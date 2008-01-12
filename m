Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbYALEoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbYALEoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 23:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbYALEnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 23:43:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41433 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbYALEnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 23:43:52 -0500
Date: Fri, 11 Jan 2008 20:45:36 -0800
From: Greg KH <greg@kroah.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO #6 retry 08/21] Utility functions and policy
	manipulationinterface.
Message-ID: <20080112044536.GA31404@kroah.com>
References: <20080109005320.323184643@nttdata.co.jp> <20080109005421.598247963@nttdata.co.jp> <Xine.LNX.4.64.0801091524500.13216@us.intercode.com.au> <Xine.LNX.4.64.0801091528160.13216@us.intercode.com.au> <200801121106.DBD21371.SVJOOHQFFLOFMt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801121106.DBD21371.SVJOOHQFFLOFMt@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 11:06:17AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> James Morris wrote:
> > > > TOMOYO Linux uses /sys/kernel/security/tomoyo interface for configuration.
> > > 
> > > Why aren't you using securityfs for this?  (It was designed for LSMs).
> > 
> > Doh, it is using securityfs, don't worry.
> > 
> I got a mm-commits mail titled
> "+ sysfs-make-sysfs_deprecated-depend-on-sysfs.patch added to -mm tree" .
> 
> Is sysfs going to be deprecated?

No, there is a config option, CONFIG_SYSFS_DEPRECATED which enables some
older sysfs symlinks and layouts.  That patch from Randy Dunlap was just
fixing up some config dependancies that were found, that's all.

> If sysfs becomes not available at /sys/ , where securityfs is going to be mounted?

sysfs is not going away any time soon, don't worry :)

thanks,

greg k-h
