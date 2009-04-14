Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbZDNVx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbZDNVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZDNVxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:53:45 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:38767 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbZDNVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:53:44 -0400
Date: Tue, 14 Apr 2009 14:53:42 -0700
From: Ira Snyder <iws@ovro.caltech.edu>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan-Bernd Themann <THEMANN@de.ibm.com>, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
Subject: Re: [RFC v2] virtio: add virtio-over-PCI driver
Message-ID: <20090414215342.GB9877@ovro.caltech.edu>
References: <20090224000002.GA578@ovro.caltech.edu> <fa686aa40904141328oa57fb1bsffd0549a52eca90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40904141328oa57fb1bsffd0549a52eca90@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 14 Apr 2009 14:53:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 02:28:26PM -0600, Grant Likely wrote:
> On Mon, Feb 23, 2009 at 6:00 PM, Ira Snyder <iws@ovro.caltech.edu> wrote:
> > This adds support to Linux for using virtio between two computers linked by
> > a PCI interface. This allows the use of virtio_net to create a familiar,
> > fast interface for communication. It should be possible to use other virtio
> > devices in the future, but this has not been tested.
> 
> Hey Ira,
> 
> I like this a lot.  I need to do much the same thing on one of my
> platforms, so I'm going to use your patch as my starting point.  Have
> you made many changes since you posted this version of your patch?
> I'd like to collaborate on the development and help to get it
> mainlined.
> 

This would be great. I'd really appreciate the help. I haven't had time
to make any changes since I last posted the patch. I started work on
converting all of the usage of struct vop_loc_* to just use the on-wire
structures, but I didn't get very far before other work got in the way.

> In my case I've got an MPC5200 as the 'host' and a Xilinx Virtex
> (ppc440) as the 'client'.  I intend set aside a region of the Xilinx
> Virtex's memory space for the shared queues.  I'm starting work on it
> now, and I'll provide you with feedback and/or patches as I make
> progress.
> 

I'm looking forward to seeing your implementation. If you have any
questions, I'd be happy to attempt to answer them :)

Ira
