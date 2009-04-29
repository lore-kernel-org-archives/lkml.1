Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbZD2LJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbZD2LJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbZD2LIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:08:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52187 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZD2LIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:08:48 -0400
Date: Wed, 29 Apr 2009 05:08:47 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: ses check name in enclosure_component_register
Message-ID: <20090429110846.GG21648@parisc-linux.org>
References: <49F6678D.3080207@kernel.org> <1240957589.3380.67.camel@mulgrave.int.hansenpartnership.com> <49F7979A.8040302@kernel.org> <1240964289.3380.73.camel@mulgrave.int.hansenpartnership.com> <49F7A71F.5040709@kernel.org> <20090429020331.GF21648@parisc-linux.org> <49F7CA9A.5000701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F7CA9A.5000701@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 08:33:46PM -0700, Yinghai Lu wrote:
> Matthew Wilcox wrote:
> > On Tue, Apr 28, 2009 at 06:02:23PM -0700, Yinghai Lu wrote:
> >> dev_set_name(cdev, name);
> >>
> >> the name become fmt. 
> > 
> > Yes, and what happens if 'name' is '%s'?
> > 
> 
> change
> dev_set_name(cdev, name);
> to
> dev_set_name(cdev, "%s", name);
> 
> didn't fix the problem.
> 
> need to check name && name[0]

Yes.  There are _two_ problems.  You fixed one.  James asked if you
would fix the other while you're touching that code.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
