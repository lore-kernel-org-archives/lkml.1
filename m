Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYHOD03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYHOD03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYHOD0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:26:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbYHOD0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:26:20 -0400
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rik van Riel <riel@redhat.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, hch@infradead.org, andi@firstfloor.org,
       viro@ZenIV.linux.org.uk, arjan@infradead.org
In-Reply-To: <20080813222353.5c809060@lxorguk.ukuu.org.uk>
References: <1218645375.3540.71.camel@localhost.localdomain>
	 <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	 <1218646065.3540.75.camel@localhost.localdomain>
	 <20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	 <1218646833.3540.82.camel@localhost.localdomain>
	 <20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	 <2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
	 <20080813173529.7069b5f1@cuia.bos.redhat.com>
	 <20080813222353.5c809060@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 23:25:57 -0400
Message-Id: <1218770757.16613.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 22:23 +0100, Alan Cox wrote:
> On Wed, 13 Aug 2008 17:35:29 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> > On Wed, 13 Aug 2008 17:24:28 -0400
> > "Press, Jonathan" <Jonathan.Press@ca.com> wrote:
> > 
> > > I may be missing something about your suggestion, but I don't see how
> > > this would work.  Who does the chmod?
> > 
> > Chmod is also not a solution to the hierarchical storage (or incremental
> > restore from backup) problem.
> > 
> > I believe we really do need the block-on-open.
> 
> The block on open is orthogonal really. Useful for HSM, useful for
> certain very primitive scanning but not much else that I can see.
> 
> And its a minor mod to the security hooks to allow it as far as I can see

So here's where I run into trouble.  Lets assume I want to be helpful
and engineer in a vacuum for this unknown HSM user as well.  Clearly
file scanners need the file to be there which means the inode ("on disk"
kind) needs to be there and stuff like that.  I assume that the HSM user
is going to need to hook long before these things even exist.  Where
would they need to hook?

Should I just design for my own needs and include stacking and a
priority number and hopefully the HSM people can use it later?  I don't
know the details of what might someday by needed for a project I know
nothing about *smile*

-Eric

