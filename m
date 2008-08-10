Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYHJDi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYHJDi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 23:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYHJDiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 23:38:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:53036 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbYHJDiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 23:38:18 -0400
Date: Sat, 9 Aug 2008 20:35:48 -0700
From: Greg KH <greg@kroah.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [00/03] [RFC] USB debugging rework
Message-ID: <20080810033548.GA30733@kroah.com>
References: <20080809013820.GA10910@kroah.com> <20080809160422.48eae96b.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809160422.48eae96b.zaitcev@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 04:04:22PM -0600, Pete Zaitcev wrote:
> On Fri, 8 Aug 2008 18:38:21 -0700, Greg KH <greg@kroah.com> wrote:
> 
> > I've been annoyed for a long time that we make users go off and rebuild
> > their kernels just to enable usb debug messages.  So finally, here's the
> > start of fixing that issue.
> 
> In many cases usbmon does the job, and it's intended to be "always-on",
> as to allow building it even on embedded kernels. Sure, it will not print
> nice values of quirks and such, but that's a trade-off. I sort of hoped
> that the switcheable explicit messages would generally die off. Look
> at ub, it only has messages which indicate error conditions.

And that's great, but for some problems we seem to keep needing to
enable debugging for either the core or the host controllers.  This
change should help with that.

thanks,

greg k-h
