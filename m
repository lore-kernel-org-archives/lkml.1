Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXFZXq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXFZXq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758004AbXFZXqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:46:20 -0400
Received: from pat.uio.no ([129.240.10.15]:60282 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbXFZXqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:46:18 -0400
Subject: Re: [RFD 0/4] AppArmor - Don't pass NULL nameidata to
	vfs_create/lookup/permission IOPs
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070626231510.883881222@suse.de>
References: <20070626231510.883881222@suse.de>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 19:46:15 -0400
Message-Id: <1182901575.12836.54.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.083)
X-UiO-Scanned: 03BF5014BDACEB15ADC4B8101EAF8D1F0C72DED8
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 236 total 2587344 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 16:15 -0700, jjohansen@suse.de wrote:
> To remove conditionally passing of vfsmounts to the LSM, a nameidata
> struct can be instantiated in the nfsd and mqueue filesystems.  This
> however results in useless information being passed down, as not
> all fields in the nameidata struct will be meaingful.  The nameidata
> struct is split creating struct nameidata2 that contains only the
> fields
> that will carry meaningful information.

I don't object to the concept per se, but could you please give it a
more descriptive name please? "struct vfs_intent" would be a lot more
accurate than "nameidata2".

Trond

