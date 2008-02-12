Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbYBLFJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbYBLFJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYBLFJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:09:07 -0500
Received: from smtp-out.google.com ([216.239.45.13]:40680 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYBLFJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:09:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=NjZxdvgDu8czSoSWfigV4vMZaL8LtNxYmOg5XPaOw/Ljzm4m2+YJudsiVLJuFi8AW
	jURBBvScfYfWHaDMxOBEg==
Date: Mon, 11 Feb 2008 21:06:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm <linux-mm@kvack.org>,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH for 2.6.24][regression fix] Mempolicy: silently restrict
 nodemask to allowed nodes V3
In-Reply-To: <20080212122637.29B7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0802112104510.21310@chino.kir.corp.google.com>
References: <alpine.LFD.1.00.0802092340400.2896@woody.linux-foundation.org> <1202748459.5014.50.camel@localhost> <20080212122637.29B7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, KOSAKI Motohiro wrote:

> [PATCH] 2.6.24 - mempolicy:  silently restrict nodemask to allowed nodes
> 

Linus has already merged this patch into his tree, but next time you 
pass along a contribution to a maintainer the first line should read:

From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

so the person who actually wrote the patch is listed as the author in the 
git commit.
