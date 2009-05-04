Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZEDOtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZEDOtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZEDOtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:49:09 -0400
Received: from kroah.org ([198.145.64.141]:42585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbZEDOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:49:08 -0400
Date: Mon, 4 May 2009 07:38:01 -0700
From: Greg KH <greg@kroah.com>
To: Jake Edge <jake@lwn.net>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       mingo@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: avoid leaking eip, esp, or wchan to
	non-privileged processes (fwd)
Message-ID: <20090504143801.GA10217@kroah.com>
References: <alpine.LRH.2.00.0905040917240.20251@tundra.namei.org> <20090503191124.27b3bf45@chukar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503191124.27b3bf45@chukar>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 07:11:24PM -0600, Jake Edge wrote:
> On Mon, 4 May 2009 09:27:29 +1000 (EST) James Morris wrote:
> > This patch needs some review.
> 
> Indeed.
> 
> > Note that stable@kernel.org typically backport already-reviewed and 
> > applied patches.  I think security@kernel.org is for reporting
> > problems in a non-public way (whereas, this is already public
> > knowledge).
> 
> I realize (now :) that I didn't get this out to all of the right folks,
> thanks for doing that.  I didn't realize security@kernel.org was only
> for non-public security problems, though.  Maybe there needs to be a
> 'security maintainer' separate from that list?  Or maybe there is one
> and I just didn't find that person in MAINTAINERS?

No, you did it correctly, as per Documentation/SecurityBugs.

And, from the MAINTAINERS file:
	SECURITY CONTACT
	P:      Security Officers
	M:      security@kernel.org
	S:      Supported

thanks,

greg k-h
