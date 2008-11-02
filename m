Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbYKBEHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbYKBEHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 00:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYKBEHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 00:07:42 -0400
Received: from kroah.org ([198.145.64.141]:55043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750804AbYKBEHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 00:07:41 -0400
Date: Sat, 1 Nov 2008 21:05:32 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.27.2 USB reset/IO Error problem when high load on ICH9 USB
Message-ID: <20081102040532.GC15360@kroah.com>
References: <1225344169.17253.43.camel@localhost> <20081031234823.5064dd88.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031234823.5064dd88.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 11:48:23PM -0700, Andrew Morton wrote:
> (cc linux-usb)
> 
> On Thu, 30 Oct 2008 06:22:49 +0100 Kasper Sandberg <lkml@metanurb.dk> wrote:
> 
> > Hello..
> > 
> > I had to write an image to some usb flash drives, more specifically, 4GB
> > kingston datatraveler sticks, and i figured, instead of doing just 1 at
> > a time, i may aswell do 4, so i plugged in 4, and started 4 dd's of the
> > images, to sdc, sdd, sde, sdf. However, i got usb disconnects and IO
> > error messages from the kernel, these are at end of message. I had
> > previously done ~5 writes of images to 5 other flash disks with no
> > problem, but when i tried the next batch, those 4, it gave these errors.
> > I killed the dd's, pulled them all out, and put in 1 at a time, and it
> > worked perfectly.

Looks like you have a hardware issue, perhaps low voltage on the ports
that cause them to be disconnected at the electrical USB level, which is
nothing that we can do about within the kernel.

thanks,

greg k-h
