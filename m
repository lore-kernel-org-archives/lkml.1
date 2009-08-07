Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbZHGAdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbZHGAdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 20:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZHGAdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 20:33:00 -0400
Received: from kroah.org ([198.145.64.141]:56204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbZHGAc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 20:32:59 -0400
Date: Thu, 6 Aug 2009 17:27:48 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090807002748.GA30062@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <9b2b86520908051355o79699e99ke045b635c6b443ad@mail.gmail.com>
 <20090806000659.GA22754@kroah.com>
 <ac3eb2510908051719o61e1d42er750fe837c824bc0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510908051719o61e1d42er750fe837c824bc0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 02:19:23AM +0200, Kay Sievers wrote:
> On Thu, Aug 6, 2009 at 02:06, Greg KH<greg@kroah.com> wrote:
> > On Wed, Aug 05, 2009 at 09:55:49PM +0100, Alan Jenkins wrote:
> 
> >> > +                   err = vfs_mkdir(nd.path.dentry->d_inode,
> >> > +                                   dentry, 0775);
> >>
> >> Is there a typo here?  I think the mode should be 0755.   0755 is used
> >> below, and that does fit better with the 0600 mode for device nodes.
> >
> > Yeah, I think you are correct.  Kay, any objection to me making this
> > change?
> 
> No, sure no objection. It sounds right to use 0755.
> I was just waiting if more things to fix come up. :)

I've made this fix in the version in my tree now.

thanks,

greg k-h
