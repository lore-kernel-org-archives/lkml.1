Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbXDIBY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbXDIBY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 21:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXDIBY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 21:24:59 -0400
Received: from ozlabs.org ([203.10.76.45]:37454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbXDIBY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 21:24:58 -0400
Subject: Re: [PATCH] Re: kernel oops with badly formatted module option
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070407194700.38138108.randy.dunlap@oracle.com>
References: <4618356D.70303@lwfinger.net>
	 <20070407194700.38138108.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 11:24:22 +1000
Message-Id: <1176081862.11664.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 19:47 -0700, Randy Dunlap wrote:
> On Sat, 07 Apr 2007 19:21:01 -0500 Larry Finger wrote:
> 
> > With the following line in /etc/modprobe.conf.local:
> > 
> > options bcm43xx fwpostfix = ".fw3" locale=8
> > 
> > the kernel oops below is generated. I realize that the line should have no whitespace around the 
> > "=", but I do not feel that an oops is the best way to report the syntax error. Could there be a more gentle failure?
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Catch malformed kernel parameter usage of "param = value".
> Spaces are not supported, but don't cause a kernel fault on
> such usage, just report an error.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks Randy,

	I even read your patch before I wrote my own, for a change!

Acked-by: Rusty Russell <rusty@rustcorp.com.au>


