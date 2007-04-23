Return-Path: <linux-kernel-owner+w=401wt.eu-S1161182AbXDWRzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182AbXDWRzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161196AbXDWRzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:55:17 -0400
Received: from ns1.suse.de ([195.135.220.2]:57103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161182AbXDWRzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:55:14 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
Date: Mon, 23 Apr 2007 19:54:46 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070414204154.871250608@goop.org> <m1vefnvvyb.fsf@ebiederm.dsl.xmission.com> <462CF0C5.2040200@zytor.com>
In-Reply-To: <462CF0C5.2040200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231954.46339.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 19:45:41 H. Peter Anvin wrote:
> Eric W. Biederman wrote:
> > 
> > - I know of one system that had BIOS tables at 16MB I believe (and
> >   thus had a fairly low hole).
> > 
> 
> Please name names, otherwise this is just rumouring.  Seriously.  We 
> have enough cargo-cult programming as it is.

Unisys did this at some point in their large machines, but they fixed
that in a later BIOS.

Anyways, boot up should be robust against any holes if possible.

-Andi

