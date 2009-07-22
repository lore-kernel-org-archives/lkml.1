Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZGVOxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZGVOxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZGVOxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:53:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42882 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZGVOxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:53:18 -0400
Subject: Re: GFS2: Add LED support to GFS2
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org, rpurdie@rpsys.net
In-Reply-To: <87k5203hdx.fsf@basil.nowhere.org>
References: <1248260198.3456.4.camel@localhost.localdomain>
	 <87k5203hdx.fsf@basil.nowhere.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 22 Jul 2009 15:51:28 +0100
Message-Id: <1248274288.3298.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-07-22 at 16:46 +0200, Andi Kleen wrote:
> Steven Whitehouse <swhiteho@redhat.com> writes:
> >
> > One possible future development is to introduce an event for
> > filesystem errors, but that is not included in the current
> > patch.
> 
> I like the idea, but it would be nicer if this was a generic
> interface into which all file systems can hook into.
> 
> -Andi
> 

It would be difficult to make that generic since the errors and the
resulting actions which can be taken vary from fs to fs. The main reason
that I didn't do it at this point in time is that the GFS2 error
handling needs revising anyway, and once that is done (probably with an
errors= option similar to ext2/3/4) it might be possible to think about
LED support for that,

Steve.


