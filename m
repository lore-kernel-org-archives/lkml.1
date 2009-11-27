Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZK0QIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZK0QIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 11:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZK0QIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 11:08:54 -0500
Received: from kroah.org ([198.145.64.141]:52699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZK0QIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 11:08:54 -0500
Date: Fri, 27 Nov 2009 08:06:43 -0800
From: Greg KH <greg@kroah.com>
To: Wei Chen <acee06.weichen@gmail.com>
Cc: chris@wirex.com, ssmalley@nai.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why the kernel remove some LSM related functions?
Message-ID: <20091127160643.GA12345@kroah.com>
References: <C5B8AF15-0D1A-4A72-AFF6-684405331FCD@osss.cs.tsukuba.ac.jp> <9C0E1031-67FD-4C14-A199-F4A878277438@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9C0E1031-67FD-4C14-A199-F4A878277438@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 09:03:17PM +0900, Wei Chen wrote:
> Recent kernel of linux has removed the exported symbol of
> register_security() for Linux Security Module; so when I want to
> develop my own security module on 2.6.28, I have to modify the kernel
> to export the symbol and recompile the kernel source. 
> 
> Besides, the kernel has completely removed the functions of
> mod_reg_security() and mod_unreg_security(), which makes me unable to
> stack the security module. The only approach is to disable the active
> security module like SELinux and register mine.
> 
> Here, I want to know why the kernel did so. 

Please read the archives and the patch changelog of the comments for
these changes, that detail why it was done.

thanks,

greg k-h
