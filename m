Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYCKGeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYCKGeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYCKGd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:33:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41168 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbYCKGdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:33:55 -0400
Date: Mon, 10 Mar 2008 23:27:51 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080311062751.GB15737@kroah.com>
References: <200803092346.17556.phillips@phunq.net> <20080311050638.GA12498@kroah.com> <200803102222.15230.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803102222.15230.phillips@phunq.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 09:22:14PM -0800, Daniel Phillips wrote:
> On Monday 10 March 2008 22:06, Greg KH wrote:
> > On Sun, Mar 09, 2008 at 10:46:16PM -0800, Daniel Phillips wrote:
> > > Set ramback to flush mode:
> > > 
> > >   echo 1 >/proc/driver/ramback/<devname>
> > 
> > /proc is so 1990's.  As your code has nothing to do with processes,
> > please don't add new files in /proc/.  sysfs is there for you to do
> > stuff like this.
> 
> Demonstrate some advantage and I will think about it.

Again, as your code has nothing to do with "processes", please do not
add new files to /proc.

As you are a filesystem, why not /sys/fs/ ?

It ends up with smaller code than procfs stuff as well, a good and nice
advantage.

thanks,

greg k-h
