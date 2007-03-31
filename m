Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbXCaRHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbXCaRHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXCaRHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:07:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54101 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbXCaRHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:07:36 -0400
Date: Sat, 31 Mar 2007 10:07:43 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ken Chen <kenchen@google.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] remove artificial software max_loop limit
Message-ID: <20070331170743.GB14596@kroah.com>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com> <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com> <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr> <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com> <20070330141524.5f6cff29.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330141524.5f6cff29.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 02:15:24PM -0700, Andrew Morton wrote:
> On Fri, 30 Mar 2007 02:25:37 -0700
> "Ken Chen" <kenchen@google.com> wrote:
> 
> > -module_param(max_loop, int, 0);
> > -MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
> 
> So..  this change will cause a fatal error for anyone who is presently
> using max_loop, won't it?  If they're doing that within their
> initramfs/initrd/etc then things could get rather ugly for them.
> 
> I don't know how much of a problem this will be in practice - do people use
> max_loop much?

Yes, the distros do, and they recommend it to their users a lot.

thanks,

greg k-h
