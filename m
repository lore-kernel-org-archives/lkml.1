Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYJLSXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYJLSXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 14:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYJLSXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 14:23:08 -0400
Received: from kroah.org ([198.145.64.141]:36576 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753482AbYJLSXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 14:23:07 -0400
Date: Sun, 12 Oct 2008 11:21:03 -0700
From: Greg KH <greg@kroah.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: WARNING on 2.6.27-rc9: sysfs: duplicate filename
	'usbdev5.5_ep89' can not be created
Message-ID: <20081012182103.GB21072@kroah.com>
References: <E1KnKmy-0006EN-Ai@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KnKmy-0006EN-Ai@closure.thunk.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 06:12:20PM -0400, Theodore Ts'o wrote:
> 
> I'm getting a whole series of warnings running 2.6.27-rc9.  I haven't
> seen them before, but then again it's been a while since I've tried
> charging my Blackberry via the USB port, which is apparently what
> triggered this.  Seems to be mostly harmless, other than dirtying up my
> logs.  :-)
> 
> Is this a known problem?

It was in the past, but should have been fixed in .27-rc.

There should be a lot of usb disconnect/connect events happening at the
same time, right?  Care to post the whole log?

Oh, and for USB stuff, try CC: linux-usb@vger.kernel.org, it works much
better :)

thanks,

greg k-h
