Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYHESCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYHESCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbYHESCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:02:03 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4321 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757478AbYHESCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:02:01 -0400
Date: Tue, 5 Aug 2008 19:35:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: david safford <safford@watson.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
Message-ID: <20080805173546.GB8380@ucw.cz>
References: <1211555145.16195.18.camel@new-host> <20080528012242.a0e98d87.akpm@linux-foundation.org> <20080531075425.GF5405@ucw.cz> <1214324935.3262.95.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214324935.3262.95.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-06-24 12:28:55, david safford wrote:
> On Sat, 2008-05-31 at 09:54 +0200, Pavel Machek wrote:
> > On Wed 2008-05-28 01:22:42, Andrew Morton wrote:
> > > On Fri, 23 May 2008 11:05:45 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > > 
> > > > This is a re-release of Integrity Measurement Architecture(IMA) as an
> > > > independent Linunx Integrity Module(LIM) service provider, which implements
> > > > the new LIM must_measure(), collect_measurement(), store_measurement(), and
> > > > display_template() API calls. The store_measurement() call supports two 
> > > > types of data, IMA (i.e. file data) and generic template data.
> > ...
> > ...also, it would be nice to see explanation 'what is this good for'.
> > 
> > Closest explanation I remember was 'it will protect you by making
> > system unbootable if someone stole disk with your /usr filesystem --
> > but not / filesystem -- added some rootkit, and then stealthily
> > returned it'. That seems a) very unlikely scenario and b) probably
> > better solved by encrypting /usr.
> > 							Pavel
> 
> Sorry about this delayed response - we are about to repost for RFC, and
> noticed we missed responding to this.
> 
> You are thinking about a related project, EVM, which HMAC's a file's
> metadata, to protect against off-line attacks, (which admittedly
> many users are not concerned about.)
> 
> This submission, IMA, provides hardware (TPM) based measurement and
> attestation, which measures all files before they are accessed in
> any way (on the inode_permission, bprm and mmap hooks), and
> commits the measurements to the TPM. The TPM can sign these 
> measurement lists, and thus the system can prove to itself and

System can never proof to itself.

> to a third party these measurements in a way that cannot be
> circumvented by malicious or compromised software. IMA is just one
> part of integrity detection, as it does not detect purely in-memory
> attacks, such as worms. 

And proofing to third party is useful for what....? Given that it can
be worked around by modifying files in memory, or by special
hardware...? Disney?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
