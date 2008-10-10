Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYJJXPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYJJXPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 19:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJJXPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 19:15:19 -0400
Received: from kroah.org ([198.145.64.141]:59912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752492AbYJJXPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 19:15:18 -0400
Date: Fri, 10 Oct 2008 16:12:08 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Rowe <david@rowetel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tzafrir Cohen <tzafrir.cohen@xorcom.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 16/23] Staging: add echo cancelation module
Message-ID: <20081010231208.GA30393@kroah.com>
References: <20081010224130.GA30117@kroah.com> <1223678567-30143-16-git-send-email-greg@kroah.com> <8bd0f97a0810101608r65fff53bi916510e47eda2a12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0810101608r65fff53bi916510e47eda2a12@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 07:08:27PM -0400, Mike Frysinger wrote:
> On Fri, Oct 10, 2008 at 18:42, Greg KH wrote:
> > +#ifdef __BLACKFIN_ASM__
> 
> shouldnt this be CONFIG_BLACKFIN or just __bfin__ ?  unless i missed
> some magic, that define doesnt get defined anywhere ...

Probably, this code still needs to be cleaned up, hence the placement in
the staging tree :)

Patches gladly accepted to fix stuff like this, and anything else people
want to help out with, are always greatly appreciated.

thanks,

greg k-h
