Return-Path: <linux-kernel-owner+w=401wt.eu-S1751531AbYJNNVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbYJNNVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYJNNVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:21:06 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:55623 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbYJNNVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:21:05 -0400
Subject: Re: [Labeled-nfs] [RFC v3] Security Label Support for NFSv4
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Cc: James Morris <jmorris@namei.org>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, labeled-nfs@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
       selinux@tycho.nsa.gov
In-Reply-To: <48F400DD.50905@sparta.com>
References: <1222707986-26606-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <alpine.LRH.1.10.0810141014580.26030@tundra.namei.org>
	 <48F400DD.50905@sparta.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 09:20:48 -0400
Message-Id: <1223990448.8907.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, MISSING_SUBJECT=0.001,NO_RECEIVED=-0.001, uiobl=NO, uiouri=NO)
X-UiO-Scanned: D86AD2A240AB96162F9F94B772E94262C4A135B0
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 98 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 22:15 -0400, Matthew N. Dodd wrote:
> James Morris wrote:
> > On Mon, 29 Sep 2008, David P. Quigley wrote:
> > 
> >> 	* New security flavor (auth_seclabel) to transport process label to
> >> 	  server. This is a derivative of auth_unix so it does not support
> >> 	  kerberos which has its own issues that need to be dealt with.
> > 
> > This is a problem, as discussed last year:
> > 
> > http://linux-nfs.org/pipermail/labeled-nfs/2007-November/000110.html
> > 
> > We can't require the use of a new auth flavor which is incompatible with 
> > auth_gss.
> 
> auth_seclabel demonstrates the flavor independent changes required for 
> any RPC layer process label transport.  A GSS solution is currently 
> under discussion.

Right, but I'm not particularly interested in merging "demonstration"
code that might end up requiring permanent support. I'd very much like
to see all of this get further through the IETF process before we talk
about merging into mainline.

Cheers
  Trond

