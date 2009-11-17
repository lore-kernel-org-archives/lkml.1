Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZKQPmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZKQPmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZKQPmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:42:16 -0500
Received: from kroah.org ([198.145.64.141]:55713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbZKQPmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:42:15 -0500
Date: Tue, 17 Nov 2009 07:41:16 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>
Subject: Re: [PATCH 0/13] sysfs lazification.
Message-ID: <20091117154116.GA22756@kroah.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <20091106224857.GB32205@kroah.com> <m1lji5h5xh.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lji5h5xh.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 01:11:22AM -0800, Eric W. Biederman wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Tue, Nov 03, 2009 at 03:53:56AM -0800, Eric W. Biederman wrote:
> >> 
> >> The sysfs code updates the vfs caches immediately when the sysfs data
> >> structures change causing a lot of unnecessary complications.  The
> >> following patchset untangles that beast.  Allowing for simpler
> >> more straight forward code, the removal of a hack from the vfs
> >> to support sysfs, and human comprehensible locking on sysfs.
> >> 
> >> Most of these patches have already been reviewed and acked from the
> >> last time I had time to work on sysfs.
> >> 
> >> In net the patches look like:
> >
> > Can you resend these based on the review that you just got, with the new
> > acks and changes so that I can apply them?
> 
> Are you going to apply them soon?  If you don't have time I can start
> a sysfs tree and just ask Linus to pull them.

Well, as the merge window is not open right now, that might be tough to
get Linus to take them at the moment :)

I was away last week, and will apply them to my tree this week, thanks
for your patience.

greg k-h
