Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbYFAOrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbYFAOrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYFAOpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:45:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4310 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751881AbYFAOpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:45:18 -0400
Date: Sat, 31 May 2008 09:54:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
Message-ID: <20080531075425.GF5405@ucw.cz>
References: <1211555145.16195.18.camel@new-host> <20080528012242.a0e98d87.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528012242.a0e98d87.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-05-28 01:22:42, Andrew Morton wrote:
> On Fri, 23 May 2008 11:05:45 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > This is a re-release of Integrity Measurement Architecture(IMA) as an
> > independent Linunx Integrity Module(LIM) service provider, which implements
> > the new LIM must_measure(), collect_measurement(), store_measurement(), and
> > display_template() API calls. The store_measurement() call supports two 
> > types of data, IMA (i.e. file data) and generic template data.
...
> Generally: the code is all moderately intrusive into the VFS and this
> sort of thing does need careful explanation and justification, please. 
> Once we have some understanding of what you're trying to achieve here
> we will inevitably ask "can't that be done in userspace".  So it would
> be best if your description were to preemptively answer all that.  

...also, it would be nice to see explanation 'what is this good for'.

Closest explanation I remember was 'it will protect you by making
system unbootable if someone stole disk with your /usr filesystem --
but not / filesystem -- added some rootkit, and then stealthily
returned it'. That seems a) very unlikely scenario and b) probably
better solved by encrypting /usr.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
