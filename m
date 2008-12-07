Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYLGHFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYLGHFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 02:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYLGHFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 02:05:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57715 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYLGHFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 02:05:12 -0500
Date: Sun, 7 Dec 2008 07:04:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       mingo@elte.hu, vegard.nossum@gmail.com, ebiederm@xmission.com,
       Yoshiya.Koyama@hp.com, rjw@sisk.pl, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data
	to userspace
Message-ID: <20081207070452.GW28946@ZenIV.linux.org.uk>
References: <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com> <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com> <20081104151234.GH28946@ZenIV.linux.org.uk> <20081106100410.GN4890@elte.hu> <20081107190544.GA1551@kroah.com> <20081107231205.GA2528@x200.localdomain> <20081111141412.b52469d2.akpm@linux-foundation.org> <20081203171854.GC17014@kroah.com> <20081203122048.b46f9fda.akpm@linux-foundation.org> <20081207054457.GC20415@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081207054457.GC20415@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 09:44:57PM -0800, Greg KH wrote:

> > Al, what's going on?  Are you thinking that I'm planning on merging
> > these myself?  Because if you're on the To: then my intention is that the
> > patch be processed by yourself.
> > 
> 
> Ping?

Still sifting through audit and VFS queues; this one (along with a bunch
of other stuff is in the latter).
