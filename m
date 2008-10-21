Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbYJUSg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYJUSg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYJUSgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:36:08 -0400
Received: from kroah.org ([198.145.64.141]:54489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754252AbYJUSgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:36:07 -0400
Date: Tue, 21 Oct 2008 11:32:10 -0700
From: Greg KH <greg@kroah.com>
To: "J.R. Mauro" <jrm8005@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: -git10 staging build warnings
Message-ID: <20081021183210.GA13391@kroah.com>
References: <48FE1459.5010205@oracle.com> <20081021180731.GA25571@kroah.com> <3aaafc130810211114p785cecabyb94d45096e6c65b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aaafc130810211114p785cecabyb94d45096e6c65b5@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 02:14:58PM -0400, J.R. Mauro wrote:
> On Tue, Oct 21, 2008 at 2:07 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Oct 21, 2008 at 10:41:45AM -0700, Randy Dunlap wrote:
> >> i386:
> >>
> >> drivers/staging/sxg/sxg.c:462: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
> >> drivers/staging/sxg/sxg.c:479: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
> >> drivers/staging/sxg/sxg.c:540: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
> >> drivers/staging/sxg/sxg.c:571: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
> 
> Greg, does this have anything to do with the fix-gcc-warnings patch I
> sent you a while back?

I don't know, I don't see that one in my "to-apply" queue, so either I
missed it, or it's already applied :)

I've now fixed this in my tree, it was a simple change.

thanks,

greg k-h
