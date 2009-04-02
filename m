Return-Path: <linux-kernel-owner+w=401wt.eu-S934722AbZDBFyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722AbZDBFyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbZDBFyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:54:07 -0400
Received: from THUNK.ORG ([69.25.196.29]:56254 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZDBFyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:54:05 -0400
Date: Thu, 2 Apr 2009 01:53:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-git: cannot mount ext4/loop
Message-ID: <20090402055356.GC10642@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com> <20090401225351.GA22621@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401225351.GA22621@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 02:53:51AM +0400, Alexander Beregalov wrote:
> On Thu, Apr 02, 2009 at 01:23:28AM +0400, Alexander Beregalov wrote:
> > Hi Theodore, Jens
> > 
> > kernel is 2.6.29-07099-g8b53ef3
> > 
> > Mount failed:
> > 
> > EXT4-fs: barriers enabled
> > kjournald2 starting: pid 1867, dev loop0:8, commit interval 5 seconds
> > EXT4-fs error (device loop0): ext4_iget: block reference 2703228928 >=
> > max (524288) in inode #2, offset=0
> > EXT4-fs: get root inode failed
> > EXT4-fs (device loop0): mount failed

I don't get this failure in a Linux 2.6 kernel based off of 5d80f8e5
with the )now upstream) ext4 patches merged in.  I'm guessing sometime
between v2.6.29-3652-g5d80f8e and 2.6.29-07099-g8b53ef3 a regression
was introduced into the loop driver?

						- Ted
