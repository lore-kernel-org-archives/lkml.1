Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbZFSXM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbZFSXM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZFSXMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:12:49 -0400
Received: from cobra.newdream.net ([66.33.216.30]:45624 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZFSXMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:12:49 -0400
Date: Fri, 19 Jun 2009 16:12:51 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/21] ceph: Ceph distributed file system client v0.9
In-Reply-To: <20090619224524.GB27322@kroah.com>
Message-ID: <Pine.LNX.4.64.0906191558440.7980@cobra.newdream.net>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
 <20090619224524.GB27322@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Greg KH wrote:
> On Fri, Jun 19, 2009 at 03:31:21PM -0700, Sage Weil wrote:
> > This is a patch series for v0.9 of the Ceph distributed file system
> > client (against v2.6.30).
> 
> Oh, one other question, why put this in staging?  What is keeping it
> being accepted into fs/ like normal?

I would obviously prefer that route, but my assumption has been that the 
code needs some review and a core developer to sign off on it before that 
can happen.  I've posted the patchset a few times now, and haven't gotten 
much response.  If there is something else I can or should be doing to 
push this upstream, I'm all ears...

The code certainly isn't ready for production, but the client code at 
least has seen relatively few changes recently.  Our internal testing is 
ramping up in scale and so far we're primarily working out problems with 
the server side daemons.  

I'm not quite sure what the criteria for mainline inclusion is, as it 
seems to vary from file system to file system, but from my perspective 
any move upstream can only help.

sage
