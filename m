Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZJ2IoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZJ2IoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZJ2IoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:44:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZJ2IoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:44:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nH/itgFIs1/zNwGw5x9W38GHGcsWERzN2qqcZO+Hwp9F1fEPytSI99Nn2vdlSBvp/
	ODO4IDf03V+AQVYLtKUXg==
Date: Thu, 29 Oct 2009 01:44:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/7] Documentation: ABI: /sys/devices/system/cpu/ topology
 files
In-Reply-To: <20091028212312.GH22743@ldl.fc.hp.com>
Message-ID: <alpine.DEB.2.00.0910290138350.11476@chino.kir.corp.google.com>
References: <20091022033506.13399.90799.stgit@bob.kio> <20091022034525.13399.4286.stgit@bob.kio> <alpine.DEB.2.00.0910281414170.27638@chino.kir.corp.google.com> <20091028212312.GH22743@ldl.fc.hp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Alex Chiang wrote:

> > I noticed that this and patches 4-6 were added to gregkh-2.6.  Alex, did 
> > you want to seperate these large multi-file sections into individual file 
> > sections so that it is consistent with the remainder of Documentation/ABI?
> 
> That's one option. Here's another:
> 
> > > +What:		/sys/devices/system/cpu/kernel_max
> > > +What:		/sys/devices/system/cpu/offline
> > > +What:		/sys/devices/system/cpu/online
> > > +What:		/sys/devices/system/cpu/possible
> > > +What:		/sys/devices/system/cpu/present
> 
> That way, your grep that you displayed in another mail still
> works.
> 
> I understand the point about consistency, but... I kinda like the
> condensed format better, since imho, it's easier to read.
> 
> Dunno, I don't have very strong feelings really... Greg already
> took them, so David, if you do have a strong feeling, let me know
> and I'll ask Greg to drop and I'll do one last respin.
> 

When I originally saw the format that the Documentation/ABI files were 
written in, I had this premonition that someone would eventually write a 
gui application that allowed users to tune their sysfs files and that it 
would inevitably include commentary on what the file represented by using 
the documentation.  It was easily parsable and had a strict file naming 
scheme that this was possible.  It seems we've departed from that at a 
relatively late stage in its maturity with no real benefit, but I'll defer 
to the maintainer's preference.

Regardless, thanks a lot for documenting these files and going the extra 
mile!  I'm sure it will come in very useful.
