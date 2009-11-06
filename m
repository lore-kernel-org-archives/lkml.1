Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbZKFXhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbZKFXhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbZKFXhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:37:19 -0500
Received: from kroah.org ([198.145.64.141]:54820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759959AbZKFXhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:37:18 -0500
Date: Fri, 6 Nov 2009 14:48:57 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>
Subject: Re: [PATCH 0/13] sysfs lazification.
Message-ID: <20091106224857.GB32205@kroah.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13a4vbz8r.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 03:53:56AM -0800, Eric W. Biederman wrote:
> 
> The sysfs code updates the vfs caches immediately when the sysfs data
> structures change causing a lot of unnecessary complications.  The
> following patchset untangles that beast.  Allowing for simpler
> more straight forward code, the removal of a hack from the vfs
> to support sysfs, and human comprehensible locking on sysfs.
> 
> Most of these patches have already been reviewed and acked from the
> last time I had time to work on sysfs.
> 
> In net the patches look like:

Can you resend these based on the review that you just got, with the new
acks and changes so that I can apply them?

thanks,

greg k-h
