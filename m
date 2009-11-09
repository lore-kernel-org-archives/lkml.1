Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZKID6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZKID6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZKID6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:58:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:57488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbZKID6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:58:03 -0500
Message-ID: <4AF7933D.6070103@kernel.org>
Date: Mon, 09 Nov 2009 12:57:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/15] sysfs lazification final
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <m1pr7tmqb4.fsf@fess.ebiederm.org>
In-Reply-To: <m1pr7tmqb4.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> The sysfs code updates the vfs caches immediately when the sysfs data
> structures change causing a lot of unnecessary complications.  The
> following patchset untangles that beast.  Allowing for simpler
> more straight forward code, the removal of a hack from the vfs
> to support sysfs, and human comprehensible locking on sysfs.
> 
> Most of these patches have already been reviewed and acked from the
> last time I had time to work on sysfs.
> 
> This acks have been folded in and the two small bugs found in the
> previous review have been fixed in the trailing patches (they are
> minor enough nits that even a bisect that happens to land in the
> middle should not see sysfs problems).

Thanks a lot for bringing some sanity to sysfs.  :-)

-- 
tejun
