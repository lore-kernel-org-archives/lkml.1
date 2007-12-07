Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbXLGWwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbXLGWwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXLGWwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:52:04 -0500
Received: from pat.uio.no ([129.240.10.15]:54982 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbXLGWwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:52:03 -0500
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Shane <gnome42@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <fa4052ef0712071139x30ada982r570513c5a0fb2657@mail.gmail.com>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	 <20071207040219.e231cbc7.akpm@linux-foundation.org>
	 <fa4052ef0712071014l524951e2we4705d84c5005cf3@mail.gmail.com>
	 <1197053179.7532.23.camel@heimdal.trondhjem.org>
	 <fa4052ef0712071055r2fe33f2ep34fed2537970c8ef@mail.gmail.com>
	 <fa4052ef0712071116x2b727faau190ec14e4b2a2d47@mail.gmail.com>
	 <fa4052ef0712071139x30ada982r570513c5a0fb2657@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 17:51:58 -0500
Message-Id: <1197067918.10831.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=5.0, autolearn=disabled, AWL=-0.180)
X-UiO-Scanned: FE5A52FD8DDDFD0D02E748A39E0C1B0765A99D7D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 177 total 5636261 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-07 at 14:39 -0500, Shane wrote:
> On Dec 7, 2007 2:16 PM, Shane <gnome42@gmail.com> wrote:
> ...
> > Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
> > spots and check for other regressions.
> 
> Hmm, I installed a new kernel built from the same sources on the NFS
> server. And now I don't see anything at all in the crossmnt dirs.
> 
> ls /dirA/dirB/dirC  --> zero output (empty dir)
> 
> Are there any other pending fixes?
> 
> Shane

You've probably fallen afoul of 

   http://bugzilla.kernel.org/show_bug.cgi?id=9504

Cheers
  Trond

