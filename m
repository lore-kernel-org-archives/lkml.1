Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbZKDWh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbZKDWh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbZKDWh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:37:28 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49291 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbZKDWh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:37:27 -0500
Date: Wed, 4 Nov 2009 16:37:28 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 13/13] sysfs: Factor out sysfs_rename from
	sysfs_rename_dir and sysfs_move_dir
Message-ID: <20091104223728.GA23322@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-13-git-send-email-ebiederm@xmission.com> <20091104221957.GB21033@us.ibm.com> <m1my32vsi1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1my32vsi1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> From: Eric W. Biederman <ebiederm@xmission.com>
> >> 
> >> These two functions do 90% of the same work and it doesn't significantly
> >> obfuscate the function to allow both the parent dir and the name to change
> >> at the same time.  So merge them together to simplify maintenance, and
> >> increase testing.
> >> 
> >> Acked-by: Tejun Heo <tj@kernel.org>
> >> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> >
> > Based on just this patchset it seems sysfs_rename() could be static,
> > but since it isn't static I assume your later patchset will use it
> > outside fs/sysfs/dir.c?
> 
> To implement sysfs_rename_link, but that is too much to digest/review/push
> all at once.

Ok, just making sure it'll get used.

To repeat myself,

Acked-by: Serge Hallyn <serue@us.ibm.com>

> I have a snapshot of my development tree up on kernel.org if you are
> interested.

I think this was an appropriately sized set :)  Might take a look this
weekend though.

thanks,
-serge
