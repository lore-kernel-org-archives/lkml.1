Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbZIJMOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbZIJMOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 08:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZIJMO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 08:14:29 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:57352 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZIJMO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 08:14:28 -0400
Subject: Re: [PATCH 3/3] sysfs: Add labeling support for sysfs
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Greg KH <gregkh@suse.de>, James Morris <jmorris@namei.org>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4AA87710.9010901@schaufler-ca.com>
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1252002358-6612-4-git-send-email-dpquigl@tycho.nsa.gov>
	 <alpine.LRH.2.00.0909071147100.2538@tundra.namei.org>
	 <1252520737.13634.833.camel@moss-pluto.epoch.ncsc.mil>
	 <alpine.LRH.2.00.0909101040460.30636@tundra.namei.org>
	 <20090910030121.GA32239@suse.de>  <4AA87710.9010901@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 10 Sep 2009 08:14:10 -0400
Message-Id: <1252584850.13634.876.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 20:48 -0700, Casey Schaufler wrote:
> Greg KH wrote:
> > On Thu, Sep 10, 2009 at 10:40:59AM +1000, James Morris wrote:
> >   
> >> Thanks, all applied to
> >> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> >>     
> >
> > Um, wait, what about the sysfs maintainer's review?  :)
> >
> > I also want to see Casey agree with this as well.
> >   
> 
> Without being able to provide a better solution in a reasonable
> time I don't see that I can responsibly raise an objection. Sure,
> I'd rather see a real implementation of xattrs on memory based
> file systems, but I can't put the time in to make it happen and
> I don't see that it would be "fair" for these people to be held
> up by my petty idiosyncrasies on the topic if I'm not willing to
> make the investment and do it myself.
> 
> Maybe the next time I'm out of work ("Nuts! And I finally got
> asking if they wanted to SuperSize it down!") I'll revive my
> efforts to eliminate secids from the kernel entirely.

Casey - we reworked the patch to avoid the use of secids in the
interface between the security module and sysfs and to support
multi-xattr security modules (by leveraging the previously discussed
hooks introduced for labeled NFS).  So I believe we went to the trouble
of addressing your concerns.  An Acked-by would be appreciated (and is
necessary at least for the changes to Smack, which we updated for you to
likewise support sysfs labeling).

-- 
Stephen Smalley
National Security Agency

