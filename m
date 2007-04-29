Return-Path: <linux-kernel-owner+w=401wt.eu-S1161561AbXD2XmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161561AbXD2XmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161569AbXD2XmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:42:08 -0400
Received: from thunk.org ([69.25.196.29]:52712 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161561AbXD2XmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:42:05 -0400
Date: Sun, 29 Apr 2007 19:42:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Wang <andrewxwang@yahoo.com.tw>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why ask Sun for ZFS while we have ReiserFS4 !?
Message-ID: <20070429234201.GB19937@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Wang <andrewxwang@yahoo.com.tw>,
	linux-kernel@vger.kernel.org
References: <660658.6960.qm@web73512.mail.tp2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <660658.6960.qm@web73512.mail.tp2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 02:18:19AM +0800, Andrew Wang wrote:
> ZFS has some nice features, but ReiserFS4 also is a
> good file system.
> 
> Why do we want Sun to release ZFS under GPL, while
> ReiserFS4 is already available under GPL!?

The people who want ZFS have in mind certain features, such as the
ability to scale to very large sizes, and ease of use when
administering filesystems that span multiple disks (ZFS subsumes the
device-mapper/RAID layer in Solaris, so they get certain performance
benefits and they are able to make it simpler to set up a filesystem
that spans multiple disks with a single command --- the flip side is
that they are violating an relatively well understood abstraction
boundary, for better or for worse).   

The claimed advantages of Reiser4 don't overlap much (if at all) with
the claimed advantages of ZFS.

> I think for those who ask/beg Sun to release ZFS under
> GPL should do the work to get ReiserFS4 to Linux!

Most of the people who have been cheerleading for either ZFS or
Reiser4 don't seme to have the necessary technical skills, alas.

					- Ted
