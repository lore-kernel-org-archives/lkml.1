Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab0BGOSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 09:18:25 -0500
Received: from kroah.org ([198.145.64.141]:60414 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab0BGOSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 09:18:24 -0500
Date: Sun, 7 Feb 2010 06:14:45 -0800
From: Greg KH <greg@kroah.com>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
       eparis@parisplace.org
Subject: Re: [PATCH] LSM: add static to security_ops variable
Message-ID: <20100207141445.GA19744@kroah.com>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 07:24:44PM +0800, wzt wzt wrote:
> security_ops was declared as a global variable, so other drivers or
> kernel code can easily change its value, like:
> 
> extern struct security_operations *security_ops;
> security_ops = NULL;
> 
> then insmod this driver immediately, it will get an oops.  Other evil
> drivers can aslo fake this variable as extern.

Evil drivers can do lots of things, if you can load a kernel module on
the system, all bets are off.  Just making this a private variable does
not mean much.

What external module are you trying to keep from using this variable?

thanks,

greg k-h
